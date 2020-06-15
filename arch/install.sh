#!/bin/bash

tput reset

# colors
__Y=$(echo -e "\e[33;1m");__A=$(echo -e "\e[36;1m");__R=$(echo -e "\e[31;1m");__O=$(echo -e "\e[m");
_n="\e[36;1m";_w="\e[37;1m";_g="\e[32;1m";_am="\e[33;1m";_o="\e[m";_r="\e[31;1m";_p="\e[33;0m";

cat <<EOL
		
		
			
			====================================================
			
				        ${__Y}INSTALADOR ARCH LINUX${__O}
					   
			====================================================
			
			==> Autor: leo.arch <leo.arch@bol.com.br>
			==> Script: arch.sh v1.0
			==> Descrição: Instalador Automático Arch Linux
			
					    ${__Y}INFORMAÇÔES${__O}
					   
			Nesse script será necessário você escolher sua par-
			tição Swap, Root e Home (Swap/Home não obrigatórias)
		
			Utilizaremos o particionador CFDISK
			
			====================================================
			
				     ${__Y}CONTINUAR COM A INSTALAÇÃO?${__O}
					
			   Digite s/S para continuar ou n/N para cancelar
			   DESEJA REALMENTE INICIAR A INSTALAÇÃO ? ${__Y}[S/n]${__O}
			   
			====================================================
EOL

setterm -cursor off
read -n 1 INSTALAR
tput reset

[[ "$INSTALAR" != @(S|s) ]] && { echo -e "\nScript cancelado!!\n"; exit 1; }

echo

lsblk -l | grep disk # list disk

echo -e "\n${_g} Logo acima estão listados os seus discos${_o}"
echo -en "\n${_g} Informe o nome do seu disco${_o} (Ex: ${_r}sda${_o}):${_w} "; read _disk; export _disk
_hd="/dev/${_disk}"; export _hd

echo

cfdisk $_hd # start partition with cfdisk

[ $? -ne 0 ] && { echo -e "\n${_r} ATENÇÃO:${_o} Disco ${_am}$_hd${_o} não existe! Execute novamente o script e insira o número corretamente.\n"; exit 1; }

tput reset; setterm -cursor off

echo -e "\n${_n} OK, você definiu as partições, caso deseje cancelar, pressione${_w}: ${_am}Ctrl+C${_o}"
echo -e "\n${_n} Use os número das partições nas perguntas abaixo${_w}\n"

echo "==========================================================="
fdisk -l $_hd
echo "==========================================================="

echo -e "\n${_n} CONSULTE ACIMA O NÚMERO DAS SUAS PARTIÇÕES${_o}"

echo -en "\n ${_p}Digite o número da partição${_o} ${_g}UEFI${_o} ou tecle ${_am}ENTER${_o} caso não tenha:${_w} "; read _uefi
echo -en "\n ${_p}Digite o número da partição${_o} ${_g}BOOT${_o} ou tecle ${_am}ENTER${_o} caso não tenha:${_w} "; read _boot
echo -en "\n ${_p}Digite o número da partição${_o} ${_g}SWAP${_o} ou tecle ${_am}ENTER${_o} caso não tenha:${_w} "; read _swap
echo -en "\n ${_p}Digite o número da partição${_o} ${_g}RAÍZ /${_o}${_am} (Partição OBRIGATÓRIA!)${_o}:${_w} "		 ; read  _root
[ "$_root" == "" ] && { echo -e "\n${_am}Atenção:${_o} ${_p}Partição RAÍZ é obrigatória! Execute novamente o script e digite o número correto!\n${_o}"; exit 1; }
echo -en "\n${_p} Digite o número da partição${_o} ${_g}HOME${_o} ou tecle ${_am}ENTER${_o} caso não tenha:${_w} "; read _home

_root="/dev/${_disk}${_root}"; export _root
[ -n "$_uefi" ] && { _uefi="/dev/${_disk}${_uefi}"; export _uefi; }
[ -n "$_boot" ] && { _boot="/dev/${_disk}${_boot}"; export _boot; }
[ -n "$_swap" ] && { _swap="/dev/${_disk}${_swap}"; export _swap; }
[ -n "$_home" ] && { _home="/dev/${_disk}${_home}"; export _home; }

echo

echo -en "${_g}Você está instalando em dualboot? Didigte s para (Sim) ou n para (Não):${_o}${_w} "; read _dualboot
[[ "$_dualboot" != @(s|n) ]] && { echo -e "\n${_am}Digite uma opção válida! s ou n\n${_o}"; exit 1; }
export _dualboot

echo

echo -en "${_g}Você está instalando em um notebook? Didigte s para (Sim) ou n para (Não):${_o}${_w} "; read _notebook
[[ "$_notebook" != @(s|n) ]] && { echo -e "\n${_am}Digite uma opção válida! s ou n\n${_o}"; exit 1; }
export _notebook

tput reset

cat <<STI
 ${__A}======================
 Iniciando a Instalação
 ======================${__O}

STI

echo -e " Suas partições definidas foram:\n"

if [[ "$_uefi" != "" ]]; then
	echo -e " ${_g}UEFI${_o} = $_uefi"
else
	echo -e " ${_g}UEFI${_o} = SEM UEFI"
fi

if [[ "$_boot" != "" ]]; then
	echo -e " ${_g}BOOT${_o} = $_boot"
else
	echo -e " ${_g}BOOT${_o} = SEM BOOT"
fi

if [[ "$_swap" != "" ]]; then
	echo -e " ${_g}SWAP${_o} = $_swap"
else
	echo -e " ${_g}SWAP${_o} = SEM SWAP"
fi

echo -e " ${_g}Raíz${_o} = $_root"

if [[ "$_home" != "" ]]; then
	echo -e " ${_g}HOME${_o} = $_home\n"
else
	echo -e " ${_g}HOME${_o} = SEM HOME\n"
fi

echo "--------------------------------"

echo

if [[ "$_dualboot" == "s" ]]; then
	echo -e " ${_g}DUAL BOOT${_o} = SIM"
else
	echo -e " ${_g}DUAL BOOT${_o} = NAO"
fi

if [[ "$_notebook" == "s" ]]; then
	echo -e " ${_g}NOTEBOOK${_o} = SIM"
else
	echo -e " ${_g}NOTEBOOK${_o} = NAO"
fi

echo

echo "==========================================================="
fdisk -l $_hd
echo "==========================================================="

echo -e "\n Verifique se as informações estão corretas comparando com os dados acima."
echo -ne "\n Se tudo estiver certo, Digite ${_g}s/S${_o} para continuar ou ${_g}n/N${_o} para cancelar: "; read -n 1 comecar

if [[ "$comecar" != @(S|s) ]]; then
	exit $?
fi

echo -e "\n\n ${_n}Continuando com a instalação ...${_o}\n"; sleep 1

# swap
if [[ "$_swap" != "" ]]; then
	echo -e "${_g}==> Criando e ligando Swap${_o}"; sleep 1
	mkswap $_swap && swapon $_swap
fi

# root
echo -e "\n${_g}==> Formatando e Montando Root${_o}"; sleep 1
mkfs.ext4 -F $_root && mount $_root /mnt

# home
if [[ "$_home" != "" ]]; then
	echo -e "${_g}==> Formatando, Criando e Montando Home${_o}"; sleep 1
	mkfs.ext4 -F $_home && mkdir /mnt/home && mount $_home /mnt/home	
fi

# efi
if [[ "$_uefi" != "" ]]; then
	echo -e "${_g}Formatando, Criando e Montando EFI${_o}"; sleep 1
	mkfs.vfat -F32 $_uefi && mkdir /mnt/boot && mount $_uefi /mnt/boot
fi

if [[ "$_boot" != "" ]]; then
	echo -e "${_g}==> Formatando, Criando e Montando BOOT${_o}"; sleep 1
	mkfs.ext4 -F $_boot && mkdir /mnt/boot && mount $_boot /mnt/boot
fi

# set morrorlist br (opcional)
# echo -e "${_g}==> Setando mirrorlist BR${_o}"; sleep 1
# wget "https://raw.githubusercontent.com/leoarch/arch/master/arch/mirrorlist" -O /etc/pacman.d/mirrorlist 2>/dev/null

# instalando base e base-devel
echo -e "${_g}==> Instalando base/base-devel${_o}"; sleep 1
pacstrap /mnt base linux linux-firmware

# gerando fstab
echo -e "${_g}==> Gerando FSTAB${_o}"; sleep 1
genfstab -U -p /mnt >> /mnt/etc/fstab

# download script mode chroot
echo -e "${_g}==> Baixando script para ser executado como chroot${_o}"; sleep 1
wget https://raw.githubusercontent.com/leoarch/arch/master/arch/chroot.sh && chmod +x chroot.sh && mv chroot.sh /mnt

# run script
echo -e "${_g}==> Executando script${_o}"; sleep 1
arch-chroot /mnt ./chroot.sh

# umount
echo -e "${_g}==> Desmontando partições${_o}"; sleep 1
umount -R /mnt

cat <<EOI

 ${__A}=============
      FIM!    
 =============${__O}
EOI

exit
