# SCS Unit IV – Static Analysis and Checklist Review

**Student Name:** Sakshi Chavan  
**Roll Number:** 3022411007  
**Subject:** Smart Contract Security Fundamentals & Auditing  
**University:** DES Pune University

## Project Overview

This practical focuses on static analysis and manual security review of the `CommunityVault.sol` smart contract using Slither.

The objective is to identify potential vulnerabilities, understand automated tool findings, perform manual checklist-based review, and document the results.

## Project Structure

- `contracts/` – Solidity smart contract
- `analysis/` – Threat model, Slither triage, manual review and wrap-up answers
- `reports/` – Slither output files and JSON findings
- `README.md` – Project overview and instructions
- `SUBMISSION_NOTES.md` – Submission notes
- `WINDOWS_SETUP.md` – Environment setup instructions

## Tools and Versions

- Solidity Compiler: 0.8.24
- Slither: 0.11.6
- solc-select: 1.2.0
- Python: 3.14.3

## Analysis Results

Slither initially reported 17 findings:

- High impact: 1
- Medium impact: 2
- Low impact: 12
- Informational: 2

After applying the documented suppression for the accepted-risk `events-access` finding, Slither reported 16 findings.

The full report, filtered report, JSON output, human summary and post-suppression report are available in the `reports/` directory.

## Manual Security Review

The manual checklist covers ten security review areas, including:

- Access control
- Reentrancy
- Arithmetic and accounting
- External calls
- Input validation
- Timestamp dependence
- Events and monitoring
- Ownership and trust assumptions
- ETH transfers
- Emergency and recovery functions

## How to Run Slither

Install Slither and Solidity compiler 0.8.24, then run:

```bash
slither contracts/CommunityVault.sol
```

To generate JSON findings:

```bash
slither contracts/CommunityVault.sol --json reports/findings.json
```

## Submission Contents

This repository contains the smart contract, threat model, static analysis reports, finding triage, manual checklist review and wrap-up answers.

**Status:** Practical analysis and documentation completed.