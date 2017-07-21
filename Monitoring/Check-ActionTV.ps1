function Check-ActionTV () {
    Invoke-WebRequest http://action.techvitality.com | `
    Format-List StatusCode, StatusDescription
}