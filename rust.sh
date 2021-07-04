# Install Rustup
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh

# Add some useful components
rustup component add clippy
rustup component add rustfmt

# Install various cargo extensions
cargo install cargo-edit
cargo install cargo-audit
cargo install cargo-expand
