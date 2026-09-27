# IT-Health-Checker-PS 

A professional PowerShell utility designed for IT administrators to quickly assess the health of a Windows machine.

##  Features

- **Disk Space Monitoring**: Checks the primary drive (C:) and warns if free space is low.
- **Resource Analysis**: Monitors RAM and CPU usage in real-time.
- **Service Watchdog**: Verifies if critical Windows services (like Spooler or WinRM) are running.
- **Connectivity Test**: Fast ping check to verify internet access.
- **Color-Coded Output**: Visual feedback (Green/Yellow/Red) for immediate status identification.

##  Installation

1. **Clone the repository**:
   \`\`\`bash
   git clone https://github.com/M1styc-sys/IT-Health-Checker-PS.git
   cd IT-Health-Checker-PS
   \`\`\`

2. **Set Execution Policy** (if not already done):
   \`\`\`powershell
   Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
   \`\`\`

##  Usage

Run the script from a PowerShell terminal:

\`\`\`powershell
.\Invoke-HealthCheck.ps1
\`\`\`

##  Output Example

\`\`\`text
--- Windows System Health Report ---
Date: 2026-09-27 10:00:00
----------------------------------------
Disk Space (C:)   : OK        [25.4% Free]
Memory Usage      : WARNING   [78.2% Used]
CPU Load          : OK        [12.5%]
Service: Spooler  : OK        [Running]
Service: WinRM    : OK        [Running]
Network (Internet): OK        [Connected]
----------------------------------------
\`\`\`

## 📜 License
This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.
