#powershell script for getting the github issue
[CmdletBinding()]
param (
    #Enter the github organization name
    [Parameter()]
    [String]
    $organization = '',


    #Enter the github repository name
    [Parameter()]
    [String]
    $repository = '',

    #Enter the person access token
    [Parameter()]
    [String[]]
    $pattoken = '',

    #enter the type in github eg: issue, Action
    [Parameter()]
    [String[]]
    $type = 'issues',

    #Enter the created date eg: format : MM/dd/yyyy
    [Parameter()]
    [String[]]
    $created_at = '',

    #Enter the updated date eg: Format : MM/dd/yyyy
    [Parameter()]
    [String[]]
    $updated_at = ''

)

$token = $pattoken
$headers = @{Authorization = "bearer $token"}

if($type -eq 'issues')
{
 $baseurl = 'https://api.github.com/orgs/'+$organization+'/'+$type
}else
{
$baseurl = 'https://api.github.com/orgs/'+$organization+'/'+'issues'
}

$result = Invoke-RestMethod -uri $baseurl -Method 'GET' -headers $headers 
$result = $result | Select-Object @{n='GIT_ISSUE_NO';e={$_.number}},
                                  @{n='DATE';e={Get-Date($_.Created_At) -Format "MM/dd/yyyy"}},
                                  @{n='TIME_STAMP';e={Get-Date($_.Created_At) -Format "MM/dd/yyyy"}},
                                  @{n='Title';e={$_.title}}, 
                                  @{n='Assignees';e={$_.assignees.login}}, 
                                  @{n='STATUS';e={$_.state}},
                                  @{n='Labels';e={$_.labels.name}},
                                  @{n='Repository';e={$_.repository.name}},
                                  @{n='COMMENTS';e={$_.comments}};


$result =$result | Where-Object {($_.CreatedDate -ge $Created_At)  -and ($_.UpdatedDate -le $Updated_At) -and $_state -eq 'All'} 
$result |  export-csv C:\Temp\listofissue.csv -NoTypeInformation
