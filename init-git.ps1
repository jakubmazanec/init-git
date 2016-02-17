Write-Host 'Initializing git repo...'

$isThereRepo = Test-Path .git

if ($isThereRepo -eq 1) {
	Write-Host 'Git repo already exists! Skipping...'
} else {
	git init
}

Write-Host

$username = Read-Host 'Set username to'
$email = Read-Host 'Set email to'
$isUsernameValid = $username -ne ''
$isEmailValid = [bool]($email -as [Net.Mail.MailAddress])

Write-Host 'Configuring git repo...'

if ($isUsernameValid -eq 1) {
	Write-Host ('Setting username to "' + $username + '"...')
	git config user.name $username
} else {
	Write-Host 'Invalid username! Skipping...'
}

if ($isEmailValid -eq 1) {
	Write-Host ('Setting email to "' + $email + '"...')
	git config user.email $email
} else {
	Write-Host 'Invalid email! Skipping...'
}

Write-Host 'Disabling fast-forward merge...'
git config merge.ff false
Write-Host 'Adding merge driver...'
git config merge.ours.driver true
git config merge.ours.name "Keep ours merge"

$caption = 'Do you want to download post-merge hook?'
$message = 'When merging to the master branch, this hook will run build task and amend changes to the merge commit.'
$yes = New-Object System.Management.Automation.Host.ChoiceDescription '&Yes','Download the hook.'
$no = New-Object System.Management.Automation.Host.ChoiceDescription '&No','Do not download anything.'
$choices = [System.Management.Automation.Host.ChoiceDescription[]]($yes,$no)
$result = $Host.UI.PromptForChoice($caption,$message,$choices,0)

if ($result -eq 0) {
	Write-Host 'Downloading hook...'
	wget https://raw.githubusercontent.com/jakubmazanec/init-git/master/post-merge_master-build-amend -OutFile .git/hooks/post-merge
} else {
	Write-Host 'Skipping...'
}

Write-Host 'Done.'
