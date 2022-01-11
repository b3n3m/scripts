$mailPath="C:\..\Mails"
Get-ChildItem $mailPath -Filter  *.msg |
ForEach-Object{
    $a = "$($_.BaseName.substring(0,15))"
    try {$date = $([datetime]::ParseExact($a, "yyyyMMdd_hhmmss", $null))} catch {$date = "failure"}
    
    if($date -isnot [DateTime]){
    $outlook = New-Object -comobject outlook.application
    $msg = $outlook.CreateItemFromTemplate($_.FullName)
    echo "$($_.BaseName.Length)"
    if($_.BaseName.length -gt 60){
    Rename-Item -LiteralPath $_.FullName -NewName "$($msg.Senton.ToString('yyyyMMdd_hhmmss'))_$($_.Basename.substring(0,59))_$($msg.SenderEmailAddress)$($_.Extension)"
    }else{
    Rename-Item -LiteralPath $_.FullName -NewName "$($msg.Senton.ToString('yyyyMMdd_hhmmss'))_$($_.Basename)_$($msg.SenderEmailAddress)$($_.Extension)"
    }
    echo "Success: $($_.Name)"

    }else{echo "Already Done: $($_.Name)"}
