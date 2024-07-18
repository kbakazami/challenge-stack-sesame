
#[derive(Debug, PartialEq, Clone)]
pub enum ToiletStatus {
    Used = 1,
    Free = 2,
    Cleaning = 3,
    Repairing = 4,
    Opening = 5,
}

impl ToiletStatus {
    pub fn id(&self) -> i32 {
        self.clone() as i32
    }
}
