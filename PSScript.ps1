#path where the user will be created
$path=Read-Host "Enter OU path, ex: OU=Users, DC=Federation"

#user name 
$firstname=Read-Host "Enter first name"
$lastname=Read-Host "Enter last name"
$username=Read-Host "Enter username"

#random character selecter
function Get-RandomCharacters($length, $characters) {
	$random = 1..$length | ForEach-Object { Get-Randonm -Maximum $characters.legth }
    $private:ofs=""
    return [String]$characters[$random]
}

#random characters to select from (can change length to make password longer/shorter)
$password = Get-RandomCharacters -length 5 -characters 'abcdefghijklmnopqrstuvwxyz'
$password += Get-RandomCharacters -length 1 -characters 'ABCDEFGHIJKLMNOPQRSTUVWXYZ'
$password += Get-RandomCharacters -length 1 -characters '1234567890'
$password += Get-RandomCharacters -length 1 -characters '!@#$%^&*()'

#creates the user
New-ADUser ` 
-SamAccountName $username ` #the account username
-UserPrincipalName "$username@Federation.local" ` #email
-Name "$firstname $lastname" ` #name of how the account shouws up in AD Users and Computers
-GivenName $firstname ` #users firstname
-Surname $lastname ` #users lastname
-Enabled $true ` #enableing the account 
-ChangePasswordAtLogon $true ` # user will need to change their password the fisrt time they login
-DisplayName "$lastname, $firstname" ` #name that is displayed on the login screen for the user
-Path $path ` # path where the user is created
-AcountPassword (convertto-securestring "$password" -AsPlainText -Force) ` #converts the $password to a securestring and sets it as the account password
-Description $password #puts the password in the discription of the user account

#logs data into .csv file
$username | Add-Content 'C:\Users\Administrators\Desktop\userExports.csv'
$password | Add-Content 'C:\Users\Administrators\Desktop\userExports.csv'
$created=Get-ADUser $username -Propetry Created | select -expand Created
$location=Get-Location
$created | Add-Content 'C:\Users\Administrators\Desktop\userExports.csv'
$location | Add-Content 'C:\Users\Administrators\Desktop\userExports.csv'
$space=" "
$space | Add-Content 'C:\Users\Administrators\Desktop\userExports.csv'

#shows the username and password, in color :)
Write-Host "username: $username" -ForegroundColor darkgreen -BackgroundColor white
Write-Host "password: $password" -ForegroundColor darkgreen -BackgroundColor white
