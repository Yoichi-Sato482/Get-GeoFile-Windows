#覆盖文件
Write-Output ">>> 准备更新文件"
#定义变量（两个文件的网络位置）
$GEOSITE_URL = "https://cdn.jsdelivr.net/gh/soffchen/sing-geosite@release/geosite.db"
$GEOIP_URL = "https://cdn.jsdelivr.net/gh/soffchen/sing-geoip@release/geoip.db"
$GEOIP_CN_URL = "https://cdn.jsdelivr.net/gh/soffchen/sing-geoip@release/geoip-cn.db"
#PATH
$GEOIP_PATH = "D:\Users\Downloads\nekoray\config\sources\geoip.db"
$GEOIP_CN_PATH = "D:\Users\Downloads\nekoray\config\sources\geoip-cn.db"
$GEOSITE_PATH = "D:\Users\Downloads\nekoray\config\sources\geosite.db"
#TEMP
$TEMP_PATH_IP = "D:\geoip.dat"
$TEMP_PATH_SITE = "D:\geosite.dat"
$TEMP_PATH_CN = "D:\geoip-cn.dat"
#BACKUP
$GEOIP_PATH_BAK = "D:\Users\Downloads\nekoray\config\sources_bak\geoip.db"
$GEOIP_CN_PATH_BAK = "D:\Users\Downloads\nekoray\config\sources_bak\geoip-cn.db"
$GEOSITE_PATH_BAK = "D:\Users\Downloads\nekoray\config\sources_bak\geosite.db"
#Start Backup
Write-Output ">>> 开始备份文件"
Copy-Item -Path $GEOIP_PATH -Destination $GEOIP_PATH_BAK -Force
Copy-Item -Path $GEOSITE_PATH -Destination $GEOSITE_PATH_BAK -Force
Copy-Item -Path $GEOIP_CN_PATH -Destination $GEOIP_CN_PATH_BAK -Force
#覆盖
try {
    Invoke-WebRequest -Uri $GEOIP_URL -OutFile $TEMP_PATH_IP
    Write-Warning ">> geoip 文件下载成功"
    Invoke-WebRequest -Uri $GEOSITE_URL -OutFile $TEMP_PATH_SITE
    Write-Warning ">> geosite 文件下载成功"
    Invoke-WebRequest -Uri $GEOIP_CN_URL -OutFile $TEMP_PATH_CN
    Write-Warning ">> geoip-cn 文件下载成功"
    Write-Output ">>> 下载成功"
    Write-Output ">>> 准备覆盖"
    Move-Item -Force $TEMP_PATH_IP $GEOIP_PATH
    Move-Item -Force $TEMP_PATH_SITE $GEOSITE_PATH
    Move-Item -Force $TEMP_PATH_CN $GEOIP_CN_PATH
}
catch {
    Write-Error "<<< 下载失败，准备还原备份"
    Copy-Item -Path $GEOIP_PATH_BAK -Destination $GEOIP_PATH -Force
    Copy-Item -Path $GEOSITE_PATH_BAK -Destination $GEOSITE_PATH -Force
    Copy-Item -Path $GEOIP_CN_PATH_BAK -Destination $GEOIP_CN_PATH -Force
    exit 1
}
try{
    Write-Warning ">>> 资源文件更新结束，是否需要重启Nekoray（1：重启 0：退出）："
    $Chooser = Read-Host
    if($Chooser = "1"){
        $Nekoray_DIR = Read-Host ">>> 请输入Nekoray进程的位置(不需要添加引號)"
        Stop-Process -Name "nekoray"
        Start-Process $Nekoray_DIR
    }
    elseif($Chooser = "0"){
        exit 1
    }
}
catch{
    Write-Error "脚本遇到问题，停止运行"    
    exit 1
}
