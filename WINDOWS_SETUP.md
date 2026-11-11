# Windows setup using WSL Ubuntu

The handout's commands use a Linux shell. On Windows, use WSL Ubuntu so Slither, solc-select and Python packages run in a supported Linux environment.

## 1. Open Ubuntu (WSL)
From PowerShell:
```powershell
wsl
```

## 2. Go to the project folder
The Windows Downloads directory is usually available in WSL at:
```bash
cd /mnt/c/Users/Dell/Downloads/SCS_Unit4_Lab_Completed
```
If you saved the folder elsewhere, adjust the path.

## 3. Install system prerequisites
```bash
sudo apt update
sudo apt install -y python3 python3-venv python3-pip build-essential
```

## 4. Create and activate a virtual environment
```bash
python3 -m venv .venv
source .venv/bin/activate
python -m pip install --upgrade pip
pip install slither-analyzer solc-select
```

## 5. Install and select Solidity 0.8.24
```bash
solc-select install 0.8.24
solc-select use 0.8.24
solc --version
slither --version
```

Record the actual outputs in the README and report.

## 6. Run the analysis
From the project root:
```bash
slither contracts/CommunityVault.sol 2>&1 | tee reports/slither-full.txt
slither contracts/CommunityVault.sol --exclude-informational --exclude-low 2>&1 | tee reports/slither-filtered.txt
slither contracts/CommunityVault.sol --list-printers 2>&1 | tee reports/slither-printers.txt
slither contracts/CommunityVault.sol --print human-summary 2>&1 | tee reports/human-summary.txt
slither contracts/CommunityVault.sol --json reports/findings.json
```

If the command cannot find `solc`, verify that the virtual environment is active and `solc-select use 0.8.24` completed.

## 7. Important
Do not add an inline suppression until you have the actual detector name and exact flagged source line. The handout requires suppressing one accepted-risk finding and verifying that exactly that result disappears. Make a backup before editing the contract, then compare the before/after reports.
