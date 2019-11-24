$global:hostname =""

Add-Type -AssemblyName System.Windows.Forms

$Form = New-Object system.Windows.Forms.Form
#$Form.Width = 800
#$Form.Height = 400

#$Icon = New-Object system.drawing.icon ("C:\Program Files\Microsoft Office\Office14\GRAPH.ICO")
$Icon = [system.drawing.icon]::ExtractAssociatedIcon($PSHOME + "\powershell.exe")

$Form.Icon = $Icon


$Form.Width = 1280
$Form.Height = 600

$Form.FormBorderStyle = [System.Windows.Forms.FormBorderStyle]::FixedSingle

$Form.Text = "Racoon Panel"

$Form.AutoScroll = $True
$Form.AutoSize = $True

$Form.MinimizeBox = $True

$Form.MaximizeBox = $False

$Form.WindowState = "Normal"

    # Maximized, Minimized, Normal

$Form.SizeGripStyle = "Hide"

    # Auto, Hide, Show

$Form.ShowInTaskbar = $True

$Form.Opacity = 1.0

    # 1.0 is fully opaque; 0.0 is invisible

$Form.StartPosition = "CenterScreen"
#$Form.StartPosition = [System.Windows.Forms.FormStartPosition]::CenterScreen

    # CenterScreen, Manual, WindowsDefaultLocation, WindowsDefaultBounds, CenterParent

#$Form.AutoSizeMode = "GrowAndShrink"
    # or GrowOnly

$Font = New-Object System.Drawing.Font("Times New Roman",12,[System.Drawing.FontStyle]::Regular)
    # Font styles are: Regular, Bold, Italic, Underline, Strikeout

$Form.Font = $Font

# $Form.BackColor = "gray"

$Label1 = New-Object System.Windows.Forms.Label
$Label1.Text = "Input Hostname or IP"
$Label1.AutoSize = $True
$Label1.BorderStyle=1
$Label1.Location=New-Object System.Drawing.Point(10, 10)
$Label1.Font=New-Object System.Drawing.Font("Times New Roman",12,[System.Drawing.FontStyle]::Bold)
$Form.Controls.Add($Label1)



    # color names are static properties of System.Drawing.Color

    # you can also use ARGB values, such as "#FFFFEBCD"



    # Add Button
    $ButtonPing = New-Object System.Windows.Forms.Button
    $ButtonPing.Location = New-Object System.Drawing.Size(100,100)
    $ButtonPing.Location = New-Object System.Drawing.Point(300,20)
    $ButtonPing.Size = New-Object System.Drawing.Size(100,30)
    $ButtonPing.Text = "Ping"

    $Form.Controls.Add($ButtonPing)


#        #Add Button event 
 #       $Button.Add_Click(
#            {    
#            [System.Windows.Forms.MessageBox]::Show("Hello World." , "My Dialog Box")
#            }
#        )



$ButtonPing_Click = 
{
    if ($textBoxHostname.Text -eq 'Hostname or IP' -or '') {
        [System.Windows.Forms.MessageBox]::Show("Invalid Hostname")
        $textBoxHostname.Text = 'Hostname or IP'
    }
    else {
    $outputBox.Clear()
    $outputBox.AppendText("`r`n In Progress..") 
    $targethost = $textBoxHostname.Text
    $output = Invoke-expression -Command ("ping $targethost | Out-String")
    $outputBox.AppendText("`r`n $output")
        } #else

}

        $ButtonPing.Add_Click($ButtonPing_Click)

##########################################################

    # IPCONFIG
    $Button_IPconfig = New-Object System.Windows.Forms.Button
    $Button_IPconfig.Location = New-Object System.Drawing.Size(100,100)
    $Button_IPconfig.Location = New-Object System.Drawing.Point(300,60)
    $Button_IPconfig.Size = New-Object System.Drawing.Size(100,30)
    $Button_IPconfig.Text = "IPCONFIG"
    $Form.Controls.Add($Button_IPconfig)


$Button_IPconfig_Click = 
{
    if ($textBoxHostname.Text -eq 'Hostname or IP' -or '') {
        [System.Windows.Forms.MessageBox]::Show("Invalid Hostname")
        $textBoxHostname.Text = 'Hostname or IP'}
    
    else {
    $outputBox.Clear()
    $outputBox.AppendText("`r`n IpConfig In Progress..") 
    $targethost = $textBoxHostname.Text

    $psexec = "$PSScriptRoot\tools\PsExec.exe"
    $pscmd = "ipconfig /all"
    $output = ((&cmd /c $psexec \\$targethost ' -n1 ' $pscmd) | Out-String )
    #$output = Invoke-expression -Command (&"$PSScriptRoot\tools\PsExec.exe \\$targethost ipconfig")

    write-host $lastexitcode
 
  #  [System.Windows.Forms.MessageBox]::Show("Hello World: " + "$x" + "$y" , "My Dialog Box Head")

    $outputBox.AppendText("`r`n $output $targethost")
    write-host $output
   [System.Windows.Forms.MessageBox]::Show("Message: $output")
       }   #else 

}

        $Button_IPconfig.Add_Click($Button_IPconfig_Click)


##########################################################
$textBoxHostname = New-Object System.Windows.Forms.TextBox
$textBoxHostname.Location = New-Object System.Drawing.Point(10,40)
$textBoxHostname.Size = New-Object System.Drawing.Size(260,20)

$textboxHostname.Add_KeyDown({
    if ($_.KeyCode -eq "Enter") {
        #logic
        $textboxHostname.Text | Out-Host
    }
})

$textBoxHostname.Text = 'Hostname or IP'

$textBoxHostname.Add_GotFocus({
    if ($textBoxHostname.Text -eq 'Hostname or IP') {
        $textBoxHostname.ForeColor = 'Black'
        $textBoxHostname.Text = ''
    }
})

$textBoxHostname.Add_LostFocus({
    if ($textBoxHostname.Text -eq '') {
        $textBoxHostname.Text = 'Hostname or IP'
        $textBoxHostname.ForeColor = 'Darkgray'
    }
})

$form.Controls.Add($textBoxHostname)


#$password = New-Object Windows.Forms.MaskedTextBox
#$password.PasswordChar = '*'
#$password.Top  = 100
#$password.Left = 10
#$form.Controls.Add($password)




$outputBox = New-Object System.Windows.Forms.TextBox 
$outputBox.Location = New-Object System.Drawing.Size(800,50) 
$outputBox.Size = New-Object System.Drawing.Size(500,500) 
$outputBox.MultiLine = $True 
$outputBox.ReadOnly = $True
$outputBox.ScrollBars = "Vertical"
$Font2 = New-Object System.Drawing.Font("Consolias",8,[System.Drawing.FontStyle]::Regular)
 # Font styles are: Regular, Bold, Italic, Underline, Strikeout
$outputBox.Font = $Font2

$outputBox.AppendText("Results:")
$outputBox.ForeColor = "White"
$outputBox.BackColor = "Black"

$Form.Controls.Add($outputBox)



$Form.ShowDialog()
#|Out-Null

