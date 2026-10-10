param([string]$vq = $(throw "Vault specification is required."),[string]$mls = $(throw "Destination e-mail addresses are required."),[string]$expirytimer = "30d")
op item list --vault $vq --format=json | jq .[].title | ForEach-Object -Process {
	$item = $_.trim("`"")
	$opbin = "op"
	$dryargs = "item", "share", $item, "--vault", $vq, "--emails", $mls, "--expires-in", $expirytimer  
	$clipd = & $opbin @dryargs
	foreach ($el in $dryargs){
		$outargs = -join ($outargs," ",$el)	
	}
	$fullout = ($fullout.length -eq 0) ? ("`n$opbin$outargs") : (-join ($fullout,"`n",$opbin,$outargs))
	$linkls = "$linkls$clipd`n"
	$outargs = "`0"
}
Set-Clipboard -Value $linkls
($linkls.length -eq 0) ? (Write-Output "The clipboard couldn't be overwritten. There could be a typo in the vault you provided, it might not exist, or there could be no items in it.") : (Write-Output "Clipboard overwritten successfully. Here's what was run:`n$fullout")