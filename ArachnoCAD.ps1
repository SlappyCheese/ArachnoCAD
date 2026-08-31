<#
.SYNOPSIS
    ArachnoCAD - Spider Web Construction Planner & Cut Sheet Generator

.DESCRIPTION
    A UI-driven tool to calculate rope lengths, generate visual layouts, and 
    export printable cut sheets for giant outdoor spider web decorations.
    Supports both Circular (Center Hub) and Triangular (Porch/Corner) designs, 
    complete with Hex-encoded share codes and integrated assembly instructions.

.VERSION
    1.2.0 - Added shape selection, hex-encoding, image export, and UI scaling.
#>

Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

[System.Windows.Forms.Application]::EnableVisualStyles()

# ==============================================================================
# 1. MAIN FORM SETUP & BRANDING
# ==============================================================================
$form = New-Object System.Windows.Forms.Form
$form.Text = "ArachnoCAD v1.2.0 - Spider Web Planner"
$form.Size = New-Object System.Drawing.Size(950, 800)$form.StartPosition = "CenterScreen"
$form.FormBorderStyle = "FixedDialog"
$form.MaximizeBox =$false

$panelLeft = New-Object System.Windows.Forms.Panel
$panelLeft.Size = New-Object System.Drawing.Size(400, 730)
$panelLeft.Location = New-Object System.Drawing.Point(10, 10)
$form.Controls.Add($panelLeft)

# --- Shape Selector ---
$lblShape = New-Object System.Windows.Forms.Label
$lblShape.Text = "Web Shape:"
$lblShape.Location = New-Object System.Drawing.Point(10, 13)
$lblShape.AutoSize =$true
$panelLeft.Controls.Add($lblShape)

$cmbShape = New-Object System.Windows.Forms.ComboBox
$cmbShape.Location = New-Object System.Drawing.Point(130, 10)
$cmbShape.Size = New-Object System.Drawing.Size(260, 25)
$cmbShape.DropDownStyle = "DropDownList"
$cmbShape.Items.Add("Circular (Center Hub)") | Out-Null
$cmbShape.Items.Add("Triangular (Corner/Porch)") | Out-Null
$cmbShape.SelectedIndex = 0
$panelLeft.Controls.Add($cmbShape)

# --- Measurement Tip Box ---
$lblMeasureTip = New-Object System.Windows.Forms.Label
$lblMeasureTip.Text = "📐 HOW TO MEASURE: Set your web size 15-20% SMALLER than the physical gap between your anchor points. You need this extra space to tie your outer tension lines!"
$lblMeasureTip.Location = New-Object System.Drawing.Point(10, 45)
$lblMeasureTip.Size = New-Object System.Drawing.Size(380, 40)
$lblMeasureTip.ForeColor = [System.
($w * 1.15, 1)
        
        $outerLength = [math]::Round([math]::Sqrt(($w/2)*($w/2) + $h*$h), 1)
        $outerCut = [math]::Round($outerLength * 1.2, 1)
        $grid.Rows.Add("Outer Edge Lines", 2, $outerLength, $outerCut) | Out-Null
        $totalExact += ($outerLength * 2)
        $totalCut += ($outerCut * 2)

        if ($spokes -gt 2) {
            $innerSpokes = $spokes - 2
            for ($i = 1; $i -le $innerSpokes; $i++) {
                $xDist = -($w/2) + ($i * ($w / ($spokes - 1)))
                $innerLength = [math]::Round([math]::Sqrt($xDist*$xDist + $h*$h), 1)
                $innerCut = [math]::Round($innerLength * 1.2, 1)
                $grid.Rows.Add("Inner Spoke $i", 1, $innerLength, $innerCut) | Out-Null
                $totalExact += $innerLength
                $totalCut += $innerCut
            }
        }

        $weaveCount = [math]::Floor($h / $space)
        for ($j = 1; $j -le $weaveCount; $j++) {
            $distFromTop = $j * $space
            $weaveLength = [math]::Round($w * ($distFromTop / $h), 1)
            $weaveCut = [math]::Round($weaveLength * 1.2, 1)
            $grid.Rows.Add("Horizontal Weave $j", 1, $weaveLength, $weaveCut) | Out-Null
            $totalExact += $weaveLength
            $totalCut += $weaveCut
        }
    }

    $rowIndex = $grid.Rows.Add("TOTAL ROPE", "--", [math]::Round($totalExact, 1), [math]::Round($totalCut, 1))
    $grid.Rows[$rowIndex].DefaultCellStyle.Font = New-Object System.Drawing.Font($grid.Font, [System.Drawing.FontStyle]::Bold)
    $grid.Rows[$rowIndex].DefaultCellStyle.BackColor = [System.Drawing.Color]::LightGray

    # ==========================================================================
    # 6. IN-MEMORY BITMAP RENDERER (For preview UI and HTML export)
    # ==========================================================================
    $bmp = New-Object System.Drawing.Bitmap($canvas.Width, $canvas.Height)
    $g = [System.Drawing.Graphics]::FromImage($bmp)
    $g.Clear([System.Drawing.Color]::White)
    $g.SmoothingMode = [System.Drawing.Drawing2D.SmoothingMode]::AntiAlias

    $cx = $canvas.Width / 2
    $cy = $canvas.Height / 2
    $padding = 20

    $penSpoke = New-Object System.Drawing.Pen([System.Drawing.Color]::DarkSlateGray, 2)
    $penRing = New-Object System.Drawing.Pen([System.Drawing.Color]::SteelBlue, 2)
    $fontOverlay = New-Object System.Drawing.Font("Consolas", 10, [System.Drawing.FontStyle]::Bold)
    $bgBrush = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(210, 255, 255, 255))
    $textBrush = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::Black)

    if (-not $isTri) {
        $radius = $dia / 2.0
        $maxPix = [math]::Min($cx, $cy) - $padding
        $scale = if ($radius -gt 0) { $maxPix / $radius } else { 1 }

        $r_px = $radius * $scale
        for ($i = 0; $i -lt $spokes; $i++) {
            $angle = $i * (360 / $spokes)
            $radAngle = $angle * [math]::PI / 180
            $x = $cx + $r_px * [math]::Cos($radAngle)
            $y = $cy + $r_px * [math]::Sin($radAngle)
            $g.DrawLine($penSpoke, $cx, $cy, [int]$x, [int]$y)
        }

        $ringCount = [math]::Floor($radius / $space)
        for ($i = 1; $i -le $ringCount; $i++) {
            $ringR_px = ($i * $space) * $scale
            $g.DrawEllipse($penRing, [int]($cx - $ringR_px), [int]($cy - $ringR_px), [int]($ringR_px * 2), [int]($ringR_px * 2))
        }
        
        $g.FillRectangle($bgBrush, 5, 5, 205, 60)
        $g.DrawString("Diameter: $dia ft", $fontOverlay, $textBrush, 10, 10)
        $g.DrawString("Anchor Gap: ~$($global:recommendedGap) ft", $fontOverlay, $textBrush, 10, 25)
        $g.DrawString("Spacing: $space ft", $fontOverlay, $textBrush, 10, 40)
    } else {
        $w = $dia
        $h = $height
        $maxDim = [math]::Max($w, $h)
        $maxPix = [math]::Min($canvas.Width/2, $canvas.Height/2) - $padding
        $scale = if ($maxDim -gt 0) { $maxPix / ($maxDim / 2.0) } else { 1 }
        
        $scaleX = ($canvas.Width - ($padding*2)) / $w
        $scaleY = ($canvas.Height - ($padding*2)) / $h
        $scale = [math]::Min($scaleX, $scaleY)

        $apexX = $cx
        $apexY = $cy - (($h/2) * $scale)
        $baseY = $apexY + ($h * $scale)
        $baseLeftX = $cx - (($w/2) * $scale)
        $baseRightX = $cx + (($w/2) * $scale)

        for ($i = 0; $i -lt $spokes; $i++) {
            $xDist = $baseLeftX + ($i * (($w * $scale) / ($spokes - 1)))
            $g.DrawLine($penSpoke, [int]$apexX, [int]$apexY, [int]$xDist, [int]$baseY)
        }

        $weaveCount = [math]::Floor($h / $space)
        for ($j = 1; $j -le $weaveCount; $j++) {
            $distFromTopPx = ($j * $space) * $scale
            $currentY = $apexY + $distFromTopPx
            $currentW = ($w * $scale) * (($j * $space) / $h)
            $leftX = $cx - ($currentW / 2)
            $rightX = $cx + ($currentW / 2)
            
            $g.DrawLine($penRing, [int]$leftX, [int]$currentY, [int]$rightX, [int]$currentY)
        }

        $g.FillRectangle($bgBrush, 5, 5, 205, 60)
        $g.DrawString("Base: $w ft (Gap: ~$($global:recommendedGap) ft)", $fontOverlay, $textBrush, 10, 10)
        $g.DrawString("Height: $h ft", $fontOverlay, $textBrush, 10, 25)
        $g.DrawString("Spacing: $space ft", $fontOverlay, $textBrush, 10, 40)
    }

    # Memory Cleanup & Push to Canvas
    $penSpoke.Dispose()
    $penRing.Dispose()
    $fontOverlay.Dispose()
    $bgBrush.Dispose()
    $textBrush.Dispose()
    $g.Dispose()

    $oldBmp = $canvas.Image
    $canvas.Image = $bmp
    if ($oldBmp) { $oldBmp.Dispose() }

    $global:isUpdating = $false
}

# ==============================================================================
# 7. EVENT HANDLERS
# ==============================================================================
$cmbShape.add_SelectedIndexChanged({ & $updateUI })

# --- HEX DECODER: Unpack string back to UI values ---
$txtCfg.add_Leave({
    $inputCode = $txtCfg.Text.Trim().ToUpper()
    if ($inputCode -match '^W-([0-9A-F]+)$') {
        try {
            $packed = [Convert]::ToInt32($Matches[1], 16)
            
            $diaInt = $packed -band 0x3F
            $heightInt = ($packed -shr 6) -band 0x3F
            $spaceInt = (($packed -shr 12) -band 0x1F) / 10.0
            $spokesInt = ($packed -shr 17) -band 0x0F
            $shapeBit = ($packed -shr 21) -band 0x01

            if ($diaInt -ge $diaGroup.Num.Minimum -and $diaInt -le $diaGroup.Num.Maximum -and
                $heightInt -ge $heightGroup.Num.Minimum -and $heightInt -le $heightGroup.Num.Maximum -and
                $spaceInt -ge $spaceGroup.Num.Minimum -and $spaceInt -le $spaceGroup.Num.Maximum -and
                $spokesInt -ge $spokeGroup.Num.Minimum -and $spokesInt -le $spokeGroup.Num.Maximum) {
                
                $global:isUpdating = $true
                $cmbShape.SelectedIndex = $shapeBit
                $diaGroup.Num.Value = $diaInt
                $heightGroup.Num.Value = $heightInt
                $spaceGroup.Num.Value = $spaceInt
                $spokeGroup.Num.Value = $spokesInt
                $global:isUpdating = $false
                & $updateUI
            }
        } catch { }
    }
})

# --- HTML GENERATOR & EXPORT ---
$btnPrint.add_Click({
    $htmlPath = Join-Path $env:TEMP "ArachnoCAD_CutSheet.html"
    
    # Convert rendered bitmap to inline Base64 for offline HTML support
    $ms = New-Object System.IO.MemoryStream
    $canvas.Image.Save($ms, [System.Drawing.Imaging.ImageFormat]::Png)
    $base64 = [Convert]::ToBase64String($ms.ToArray())
    $ms.Dispose()
    $imgSrc = "data:image/png;base64,$base64"

    $tableHtml = ""
    foreach ($row in $grid.Rows) {
        $comp = $row.Cells[0].Value
        $qty = $row.Cells[1].Value
        $exact = $row.Cells[2].Value
        $cut = $row.Cells[3].Value
        
        $style = if ($comp -eq "TOTAL ROPE") { "style='font-weight:bold; background-color:#e0e0e0;'" } else { "" }
        $tableHtml += "<tr $style><td>$comp</td><td>$qty</td><td>$exact ft</td><td>$cut ft</td></tr>`n"
    }
    
    $specs = if ($cmbShape.SelectedIndex -eq 0) {
        "$($diaGroup.Num.Value) ft Diameter &bull; $($spaceGroup.Num.Value) ft Ring Spacing &bull; $($spokeGroup.Num.Value) Spokes"
    } else {
        "$($diaGroup.Num.Value) ft Base x $($heightGroup.Num.Value) ft Height &bull; $($spaceGroup.Num.Value) ft Spacing &bull; $($spokeGroup.Num.Value) Spokes"
    }

    $htmlContent = @"
<!DOCTYPE html>
<html>
<head>
    <title>ArachnoCAD Build Plan</title>
    <style>
        body { font-family: Arial, sans-serif; margin: 30px; line-height: 1.4; max-width: 1000px; }
        h1 { color: #2c3e50; border-bottom: 2px solid #2c3e50; padding-bottom: 10px; }
        .version { font-size: 14px; color: #7f8c8d; font-weight: normal; margin-left: 10px; }
        .config-box { background: #f4f4f4; padding: 10px; border-radius: 5px; font-weight: bold; font-family: monospace; display: inline-block; }
        table { width: 100%; border-collapse: collapse; margin-top: 15px; }
        th, td { border: 1px solid #ddd; padding: 10px; text-align: left; }
        th { background-color: #34495e; color: white; }
        .knot-section { margin-top: 30px; background: #fafafa; padding: 20px; border-left: 5px solid #3498db; display: flex; align-items: center; gap: 30px; page-break-inside: avoid; }
        .knot-text { flex: 1; }
        .knot-img { max-width: 150px; }
        .layout-grid { display: flex; gap: 30px; margin-top: 20px; }
        .column { flex: 1; }
        .preview-img { width: 100%; max-width: 400px; border: 1px solid #ccc; border-radius: 5px; display: block; margin: 0 auto 15px auto; }
        .assembly-box { background: #eef2f5; padding: 15px; border-radius: 5px; }
        .assembly-box ol { margin: 0; padding-left: 20px; }
        .assembly-box li { margin-bottom: 8px; }
        @media print { button { display: none; } }
    </style>
</head>
<body>
# ==============================================================================
# 7. EVENT HANDLERS
# ==============================================================================
$cmbShape.add_SelectedIndexChanged({ & $updateUI })

# --- HEX DECODER: Unpack string back to UI values ---
$txtCfg.add_Leave({
    $inputCode = $txtCfg.Text.Trim().ToUpper()
    if ($inputCode -match '^W-([0-9A-F]+)$') {
        try {
            $packed = [Convert]::ToInt32($Matches[1], 16)
            
            $diaInt = $packed -band 0x3F
            $heightInt = ($packed -shr 6) -band 0x3F
            $spaceInt = (($packed -shr 12) -band 0x1F) / 10.0
            $spokesInt = ($packed -shr 17) -band 0x0F
            $shapeBit = ($packed -shr 21) -band 0x01

            if ($diaInt -ge $diaGroup.Num.Minimum -and $diaInt -le $diaGroup.Num.Maximum -and
                $heightInt -ge $heightGroup.Num.Minimum -and $heightInt -le $heightGroup.Num.Maximum -and
                $spaceInt -ge $spaceGroup.Num.Minimum -and $spaceInt -le $spaceGroup.Num.Maximum -and
                $spokesInt -ge $spokeGroup.Num.Minimum -and $spokesInt -le $spokeGroup.Num.Maximum) {
                
                $global:isUpdating = $true
                $cmbShape.SelectedIndex = $shapeBit
                $diaGroup.Num.Value = $diaInt
                $heightGroup.Num.Value = $heightInt
                $spaceGroup.Num.Value = $spaceInt
                $spokeGroup.Num.Value = $spokesInt
                $global:isUpdating = $false
                & $updateUI
            }
        } catch { }
    }
})

# --- HTML GENERATOR & EXPORT ---
$btnPrint.add_Click({
    $htmlPath = Join-Path $env:TEMP "ArachnoCAD_CutSheet.html"
    
    # Convert rendered bitmap to inline Base64 for offline HTML support
    $ms = New-Object System.IO.MemoryStream
    $canvas.Image.Save($ms, [System.Drawing.Imaging.ImageFormat]::Png)
    $base64 = [Convert]::ToBase64String($ms.ToArray())
    $ms.Dispose()
    $imgSrc = "data:image/png;base64,$base64"

    $tableHtml = ""
    foreach ($row in $grid.Rows) {
        $comp = $row.Cells[0].Value
        $qty = $row.Cells[1].Value
        $exact = $row.Cells[2].Value
        $cut = $row.Cells[3].Value
        
        $style = if ($comp -eq "TOTAL ROPE") { "style='font-weight:bold; background-color:#e0e0e0;'" } else { "" }
        $tableHtml += "<tr $style><td>$comp</td><td>$qty</td><td>$exact ft</td><td>$cut ft</td></tr>`n"
    }
    
    $specs = if ($cmbShape.SelectedIndex -eq 0) {
        "$($diaGroup.Num.Value) ft Diameter &bull; $($spaceGroup.Num.Value) ft Ring Spacing &bull; $($spokeGroup.Num.Value) Spokes"
    } else {
        "$($diaGroup.Num.Value) ft Base x $($heightGroup.Num.Value) ft Height &bull; $($spaceGroup.Num.Value) ft Spacing &bull; $($spokeGroup.Num.Value) Spokes"
    }

    $htmlContent = @"
<!DOCTYPE html>
<html>
<head>
    <title>ArachnoCAD Build Plan</title>
    <style>
        body { font-family: Arial, sans-serif; margin: 30px; line-height: 1.4; max-width: 1000px; }
        h1 { color: #2c3e50; border-bottom: 2px solid #2c3e50; padding-bottom: 10px; }
        .version { font-size: 14px; color: #7f8c8d; font-weight: normal; margin-left: 10px; }
        .config-box { background: #f4f4f4; padding: 10px; border-radius: 5px; font-weight: bold; font-family: monospace; display: inline-block; }
        table { width: 100%; border-collapse: collapse; margin-top: 15px; }
        th, td { border: 1px solid #ddd; padding: 10px; text-align: left; }
        th { background-color: #34495e; color: white; }
        .knot-section { margin-top: 30px; background: #fafafa; padding: 20px; border-left: 5px solid #3498db; display: flex; align-items: center; gap: 30px; page-break-inside: avoid; }
        .knot-text { flex: 1; }
        .knot-img { max-width: 150px; }
        .layout-grid { display: flex; gap: 30px; margin-top: 20px; }
        .column { flex: 1; }
        .preview-img { width: 100%; max-width: 400px; border: 1px solid #ccc; border-radius: 5px; display: block; margin: 0 auto 15px auto; }
        .assembly-box { background: #eef2f5; padding: 15px; border-radius: 5px; }
        .assembly-box ol { margin: 0; padding-left: 20px; }
        .assembly-box li { margin-bottom: 8px; }
        @media print { button { display: none; } }
    </style>
</head>
<body>
    <button onclick="window.print()" style="float:right; padding: 10px 20px; font-size: 14px; cursor:pointer; background-color: #3498db; color: white; border: none; border-radius: 5px;">Print Plan</button>
    <h1>ArachnoCAD Construction Plan<span class="version">v1.2.0</span></h1>
    <p><strong>Share Code:</strong> <span class="config-box">$($txtCfg.Text)</span></p>
    <p><strong>Specifications:</strong> $specs</p>
    <p><strong>Recommended Anchor Gap:</strong> ~ $($global:recommendedGap) ft (Allows room for tension lines)</p>

    <div class="layout-grid">
        <div class="column">
            <h2>Itemized Cut Sheet</h2>
            <table>
                <thead>
                    <tr>
                        <th>Component</th>
                        <th>Qty</th>
                        <th>Exact Length</th>
                        <th>Cut Length (+20%)</th>
                    </tr>
                </thead>
                <tbody>
                    $tableHtml
                </tbody>
            </table>
        </div>
        
        <div class="column">
            <h2>Visual Plan</h2>
            <img src="$imgSrc" class="preview-img" alt="Web Preview" />
            
            <div class="assembly-box">
                <h3 style="margin-top: 0;">Assembly Order</h3>
                <ol>
                    <li><strong>Anchor the Frame:</strong> Secure your main structural lines (the cross or outer triangle) tightly across your space.</li>
                    <li><strong>Set the Spokes:</strong> Tie the remaining radial lines to the center hub or apex.</li>
                    <li><strong>Weave the Spiral/Rings:</strong> Start from the center and work outward, tying a clove hitch at every intersection. Keep the cord slightly loose so the web has a natural sag.</li>
                    <li><strong>Final Tension:</strong> Once fully woven, pull your master anchor lines tighter to lock the whole structure in place.</li>
                </ol>
            </div>
        </div>
    </div>

    <div class="knot-section">
        <div class="knot-text">
            <h2 style="margin-top: 0;">Assembly Knot: The Clove Hitch</h2>
            <ul style="padding-left: 20px;">
                <li><strong>Why:</strong> It grips the main structural lines tightly under tension, preventing sags, but allows you to slide the knot along the spoke to fine-tune spacing before locking it in.</li>
                <li><strong>How to tie:</strong>
                    <ol>
                        <li>Wrap the working end of the ring line over and around the spoke.</li>
                        <li>Cross back over the first wrap to form an "X".</li>
                        <li>Pass the cord around the spoke one more time and tuck it underneath the middle of the "X".</li>
                        <li>Pull both ends tightly to lock.</li>
                    </ol>
                </li>
            </ul>
        </div>
        <svg class="knot-img" viewBox="0 0 100 100" xmlns="http://www.w3.org/2000/svg">
            <rect x="40" y="5" width="20" height="90" rx="3" fill="#cbd5e1" stroke="#94a3b8" stroke-width="2"/>
            <path d="M 15 70 Q 50 90 85 70" fill="none" stroke="#f97316" stroke-width="9" stroke-linecap="round"/>
            <path d="M 15 70 C 20 40 80 40 85 40" fill="none" stroke="#ea580c" stroke-width="9" stroke-linecap="round"/>
            <path d="M 15 30 C 20 60 80 60 85 70" fill="none" stroke="#f97316" stroke-width="9" stroke-linecap="round"/>
            <path d="M 15 30 Q 50 10 85 30" fill="none" stroke="#ea580c" stroke-width="9" stroke-linecap="round"/>
            <path d="M 85 40 Q 60 45 40 50" fill="none" stroke="#c2410c" stroke-width="9" stroke-linecap="round"/>
        </svg>
    </div>
</body>
</html>
"@

    $htmlContent | Out-File -FilePath $htmlPath -Encoding utf8
    Start-Process $htmlPath
})

# Link Value/Scroll events to trigger UI redraws
$diaGroup.Num.add_ValueChanged($updateUI)
$heightGroup.Num.add_ValueChanged($updateUI)
$spaceGroup.Num.add_ValueChanged($updateUI)
$spokeGroup.Num.add_ValueChanged($updateUI)

$diaGroup.Tb.add_Scroll({ if (!$global:isUpdating) { $diaGroup.Num.Value = $diaGroup.Tb.Value } })
$heightGroup.Tb.add_Scroll({ if (!$global:isUpdating) { $heightGroup.Num.Value = $heightGroup.Tb.Value } })
$spaceGroup.Tb.add_Scroll({ if (!$global:isUpdating) { $spaceGroup.Num.Value = $spaceGroup.Tb.Value / 10.0 } })
$spokeGroup.Tb.add_Scroll({ if (!$global:isUpdating) { $spokeGroup.Num.Value = $spokeGroup.Tb.Value } })

# Initialize
& $updateUI

$form.ShowDialog() | Out-Null
$form.Dispose()

   
