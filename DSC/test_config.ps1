Configuration TestConfig {
    Node "10.11.57.1" {
        WindowsFeature 'Webserver' {
            Name = 'web-server'
            Ensure = 'Present'
            IncludeAllSubFeature = $true
        }
        WindowsFeature Storage {
            Name = 'FileAndStorage-Services'
            Ensure = 'Present'
            IncludeAllSubFeature = $true
        }
    }
}

TestConfig