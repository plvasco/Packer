Set-Location C:\s3-downloads
Expand-Archive .\Chocopkg4Download.zip



choco install -y bigfixagent --source=C:\s3-downloads\Chocopkg4Download\Chocopkg4Download\Chocopackages\bigfixagent
choco install -y mcafeeagent --source=C:\s3-downloads\Chocopkg4Download\Chocopkg4Download\Chocopackages\mcafeeagent
choco install -y wincollect --source=C:\s3-downloads\Chocopkg4Download\Chocopkg4Download\Chocopackages\wincollect
choco install -y safenet --source=C:\s3-downloads\Chocopkg4Download\Chocopkg4Download\Chocopackages\safenet
choco install -y splunk
choco install -y awscli           
