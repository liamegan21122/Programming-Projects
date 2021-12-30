#[derive(Debug)]
#[derive(PartialEq)]
pub enum Command
{
    Power(bool,i32),    // [Increase/Decrease] power by [number].
    Missiles(bool,i32), // [Increase/Decrease] missiles by [number].
    Shield(bool),       // Turn [On/Off] the shield.
    Try,                // Try calling pepper.
    Invalid             // [anything else]
}


/**
    Adds functionality to Command enums
    Commands can be converted to strings with the as_str method
    
    Command     |     String format
    ---------------------------------------------------------
    Power       |  /Power (increased|decreased) by [0-9]+%/
    Missiles    |  /Missiles (increased|decreased) by [0-9]+/
    Shield      |  /Shield turned (on|off)/
    Try         |  /Call attempt failed/
    Invalid     |  /Not a command/
**/
impl Command {
    pub fn as_str (&self) -> String {
        match self {
            Command::Power(true,value) => ("Power increased by ".to_owned() + &value.to_string() + "%").to_string(),
            
            Command::Power(false, value) => ("Power decreased by ".to_owned() + &value.to_string() + "%").to_string(),
            
            Command::Missiles(true, value) => ("Missiles increased by ".to_owned() + &value.to_string()).to_string(),
            
            Command::Missiles(false, value) => ("Missiles decreased by ".to_owned() + &value.to_string()).to_string(),
            
            Command::Shield(true) => ("Shield turned on".to_owned()).to_string(),
            
            Command::Shield(false) => ("Shield turned off".to_owned()).to_string(),
            
            Command::Try => ("Call attempt failed".to_owned()).to_string(),
            
            Command::Invalid => ("Not a command".to_owned()).to_string(),
        }
    }
}

/**
    Complete this method that converts a string to a command 
    We list the format of the input strings below

    Command     |     String format
    ---------------------------------------------
    Power       |  /power (inc|dec) [0-9]+/
    Missiles    |  /(fire|add) [0-9]+ missiles/
    Shield      |  /shield (on|off)/
    Try         |  /try calling Miss Potts/
    Invalid     |  Anything else
**/
pub fn to_command(s: &str) -> Command {
    if s.contains(/power (inc|dec [0-9]+/){
        let sum = &s[10..].to_owned();
        let num: i32 = sum.parse().unwrap();
        if s.contains("inc"){
            return Command::Power(true, num)
        }
        if s.contains ("dec"){
            return Command::Power(false, num)
        }
        else{
            return Command::Invalid
        }
    }
    
    if s.contains("missiles"){
        if s.contains("add"){
            let sum = &s[4..6].to_owned();
            let num: i32 = sum.parse().unwrap();
            return Command::Missiles(true, num)
        }
        if s.contains("fire"){
            let sum = &s[5..7].to_owned();
            let num: i32 = sum.parse().unwrap();
            return Command::Missiles(false, num)
        }
        else{
            return Command::Invalid
        }
    }
    
    if s.contains("shield"){
        if s.contains("on"){
            return Command::Shield(true)
        }
        if s.contains("off"){
            return Command::Shield(false)
        }
        else{
            return Command::Invalid
        }
    }
    
    if s.contains("try calling Miss Potts"){
        return Command::Try
    }
    
    if s.contains("Anything else"){
        return Command::Invalid
    }
    
    else{
        return Command::Invalid
    }
}
