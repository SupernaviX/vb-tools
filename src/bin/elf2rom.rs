use anyhow::{anyhow,Result};
use elf::{endian::AnyEndian, section::SectionHeader};
use std::{fs::{self, File}, path::PathBuf, io::{Write, Seek}};
use structopt::StructOpt;

type ElfData<'a> = elf::ElfBytes::<'a, AnyEndian>;

#[derive(Debug, StructOpt)]
struct Cli {
    /// ELF file to convert
    #[structopt(parse(from_os_str))]
    elf: PathBuf,
    /// Path to write the rom (defaults to the path of the elf file, but with a .vb extension)
    #[structopt(parse(from_os_str))]
    rom: Option<PathBuf>,
}

fn main() -> Result<()> {
    let args = Cli::from_args();
    let bytes = fs::read(&args.elf)?;
    let elf = ElfData::minimal_parse(bytes.as_slice())?;

    let outpath = get_output_path(&args)?;
    let mut rom = File::create(outpath)?;

    output_section(&elf, &mut rom, ".text")?;
    output_section(&elf, &mut rom, ".rodata")?;
    output_section(&elf, &mut rom, ".data")?;
    output_section_at_end(&elf, &mut rom, ".vbheader")?;

    Ok(())
}

fn get_output_path(cli: &Cli) -> Result<PathBuf> {
    if let Some(path) = cli.rom.as_ref() {
        return Ok(path.clone())
    }
    let path = &cli.elf;
    let filename = path.file_name().ok_or_else(|| anyhow!("Invalid path"))?;
    let mut path = PathBuf::from(filename);
    path.set_extension("vb");
    return Ok(path);
}

fn output_section(elf: &ElfData, rom: &mut File, section: &str) -> Result<()> {
    let header = find_section_by_name(elf, section)?;
    output_section_data(elf, rom, &header)
}

fn output_section_at_end(elf: &ElfData, rom: &mut File, section: &str) -> Result<()> {
    let header = find_section_by_name(elf, section)?;

    let current_pos = rom.stream_position()?;
    let target_pos = current_pos.next_power_of_two() - header.sh_size;

    rom.seek(std::io::SeekFrom::Start(target_pos))?;
    output_section_data(elf, rom, &header)
}

fn find_section_by_name(elf: &ElfData, section: &str) -> Result<SectionHeader> {
    elf.section_header_by_name(section)?
        .ok_or_else(|| anyhow!("section {} not found", section))
}

fn output_section_data(elf: &ElfData, rom: &mut File, header: &SectionHeader) -> Result<()> {
    let (contents, _) = elf.section_data(&header)?;
    rom.write(contents)?;
    Ok(())
}
