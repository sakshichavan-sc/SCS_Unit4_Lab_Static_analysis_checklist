# Unit IV Lab — Static Analysis and Checklist Review

## Student details
- Name: Sakshi Chavan
- Roll number: 3022411007
- Course: B.Sc. Blockchain Technology
- Lab: Unit IV — Practicals 7 & 8
- Contract: `contracts/CommunityVault.sol`
- Compiler required by handout: Solidity 0.8.24

## Aim
Run Slither against the supplied CommunityVault contract, understand each finding, classify it, and then perform a manual checklist review to identify issues that a static analyser may not explain or detect.

This is an ungraded practice lab. The supplied contract is intentionally unannotated. The original contract is preserved unchanged for the initial analysis.

## Project contents
```text
SCS_Unit4_Lab_Completed/
├── contracts/
│   └── CommunityVault.sol
├── reports/
├── screenshots/
├── analysis/
│   ├── threat-model.md
│   ├── manual-review.md
│   ├── slither-triage-template.md
│   └── wrap-up.md
├── .gitignore
├── README.md
└── WINDOWS_SETUP.md
```

## Tool setup
The handout asks for Python 3, Slither, solc-select and Solidity 0.8.24. Because this project is being prepared on Windows, the supplied setup guide uses WSL Ubuntu commands.

After installing the tools, record the actual outputs of:
```bash
python3 --version
slither --version
solc --version
```

## Run Slither
From the project root, with the Python virtual environment active and Solidity 0.8.24 selected:

```bash
slither contracts/CommunityVault.sol 2>&1 | tee reports/slither-full.txt
slither contracts/CommunityVault.sol --exclude-informational --exclude-low
slither contracts/CommunityVault.sol --list-printers
slither contracts/CommunityVault.sol --print human-summary
slither contracts/CommunityVault.sol --json reports/findings.json
```

Record the total result count, remaining count after filtering, and all High-impact detector names in `analysis/slither-triage-template.md`.

**Important:** Slither has not been run in this prepared ZIP. The triage notes are manual candidate findings based on reading the source. Confirm the exact detector names, line numbers, impact and confidence against your own Slither output. Do not report the candidate list as Slither's actual output.

## Analysis files
- `analysis/threat-model.md`: initial actors, assets, trust assumptions and invariants.
- `analysis/manual-review.md`: checklist results and issues that require business-context judgement.
- `analysis/slither-triage-template.md`: table to complete from actual Slither output.
- `analysis/wrap-up.md`: draft answers to the four handout questions.

## Evidence
Save the full terminal output and JSON report in `reports/`. Put your own terminal screenshots in `screenshots/`. Do not fabricate tool output or version numbers.

## Current status
- [x] CommunityVault source copied from the handout Appendix A.
- [x] Initial threat model drafted.
- [x] Manual code review drafted.
- [x] Wrap-up questions drafted.
- [ ] Install and record Slither / solc versions.
- [ ] Run Slither and save full text + JSON output.
- [ ] Triage every actual finding.
- [ ] Complete filtered output and human-summary counts.
- [ ] Add one justified inline suppression and verify exactly one result disappears.
- [ ] Capture terminal evidence.
- [ ] Final review.

## Safety
This contract contains serious security weaknesses and is for local educational analysis only. Do not deploy it or use it to hold real ETH.
