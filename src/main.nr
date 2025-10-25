//using a dependency ecrecover ; importing the library
use dep::ecrecover;

//the function has 4 inputs of u8 size 32
//signatures usually have size 65 but here only 64 since we want only the beginning parts
fn main(
    pub_key_x: [u8; 32],
    pub_key_y: [u8; 32],
    signature: [u8; 64],
    hashed_message: [u8; 32],
    expected_address: Field,
) {
    let address = ecrecover::ecrecover(pub_key_x, pub_key_y, signature, hashed_message);
    assert(address == expected_address, "Address does not match here!");
}

//the 64 byte signature component above represents the 32 bypte 'r' and 32 byte 's' values concatenated together
//and a 1 byte recovery ID 'v' is omitted here since it is not required for this implementation

#[test]
fn test_main() {

    // Uncomment to make test fail
    // main(1, 1);
}
