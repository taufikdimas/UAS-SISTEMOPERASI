#!/bin/bash

show_menu() {
    echo "╔════════════════════════════════╗"
    echo -e "║   ${BLUE}    Pilih Menu TransPDF   ${NC}  ║"
    echo "╠════════════════════════════════╣"
    echo "║1.  Word ke PDF                 ║"
    echo "║2.  PDF ke Word                 ║"
    echo "║3.  PPT ke PDF                  ║"
    echo "║4.  PDF ke PPT                  ║"
    echo "║5.  Excel ke PDF                ║"
    echo "║6.  JPG ke PDF                  ║"
    echo "║7.  Gabungkan PDF               ║" 
    echo "║8.  Pisahkan PDF                ║"
    echo "║9.  Kompress PDF                ║"
    echo "║10. Kunci PDF                   ║"
    echo "║11. Buka kunci PDF              ║"
    echo "║12. Ubah kunci PDF              ║"
    echo "║0.  Keluar                      ║"
    echo "╚════════════════════════════════╝"
}

# warna
PINK='\033[38;5;205m'
YELLOW='\033[38;5;226m'
GREEN='\033[38;5;82m'
RED='\033[38;5;196m'
BLUE='\033[38;5;27m'
NC='\033[0m' 

# konversi dokumen menggunakan libreoffice
convert_to_pdf() {
    input_file=$1
    output_format=$2
    libreoffice --headless --convert-to "$output_format" "$input_file"
    if [ $? -eq 0 ]; then
        echo -e "${GREEN}Konversi berhasil: ${input_file}${NC} -> ${YELLOW}${output_format}${NC}"
    else
        echo -e "${RED}Konversi gagal${NC}"
    fi
}

# konversi PDF ke Word menggunakan pdftotext dan pandoc
convert_pdf_to_word() {
    input_file=$1
    output_file=$2
    pdftotext "$input_file" temp.txt
    pandoc temp.txt -o "$output_file"
    if [ $? -eq 0 ]; then
        echo -e "${GREEN}Konversi berhasil: ${input_file} -> ${output_file}${NC}"
    else
        echo -e "${RED}Konversi gagal${NC}"
    fi
    rm temp.txt
}

# konversi PDF ke PPT menggunakan pdf2pptx
convert_pdf_to_ppt() {
    input_file=$1
    output_file=$2
    pdf2pptx "$input_file" -o "$output_file"
    if [ $? -eq 0 ]; then
        echo -e "${GREEN}Konversi berhasil: ${input_file} -> ${output_file}${NC}"
    else
        echo -e "${RED}Konversi gagal${NC}"
    fi
}

# menggabungkan PDF menggunakan pdftk
merge_pdfs() {
    output_file=$1
    shift
    input_files=$@
    pdftk $input_files cat output "$output_file"
    if [ $? -eq 0 ]; then
        echo -e "${GREEN}Penggabungan berhasil: $output_file${NC}"
    else
        echo -e "${RED}Gagal menggabungkan PDF${NC}"
    fi
}

# memisahkan PDF menggunakan pdfseparate
split_pdf() {
    input_file=$1
    output_pattern=$2
    pdfseparate "$input_file" "$output_pattern"
    if [ $? -eq 0 ]; then
        echo -e "${GREEN}Pemisahan berhasil${NC}"
    else
        echo -e "${RED}Gagal Mempisahkan PDF${NC}"
    fi
}

# mengompres PDF menggunakan Ghostscript
compress_pdf() {
    input_file=$1
    output_file=$2
    gs -sDEVICE=pdfwrite -dCompatibilityLevel=1.4 -dPDFSETTINGS=/screen -dNOPAUSE -dQUIET -dBATCH -sOutputFile="$output_file" "$input_file"
    if [ $? -eq 0 ]; then
        echo -e "${GREEN}Kompresi berhasil: $output_file${NC}"
    else
        echo -e "${RED}Gagal Mengkompres PDF${NC}"
    fi
}
# mengunci PDF menggunakan qpdf
lock_pdf() {
    input_file=$1
    output_file=$2
    password=$3
    qpdf --encrypt "$password" "$password" 256 -- "$input_file" "$output_file"
    if [ $? -eq 0 ]; then
        echo -e "${GREEN}File berhasil dikunci: $output_file${NC}"
    else
        echo -e "${RED}Gagal Mengunci File${NC}"
    fi
}

# membuka kunci PDF menggunakan qpdf
unlock_pdf() {
    input_file=$1
    output_file=$2
    password=$3
    qpdf --decrypt --password="$password" "$input_file" "$output_file"
    if [ $? -eq 0 ]; then
        echo -e "${GREEN}File berhasil dibuka kuncinya: $output_file${NC}"
    else
        echo -e "${RED}Gagal Membuaka Kunci File${NC}"
    fi
}

# mengubah kunci PDF menggunakan qpdf
change_pdf_password() {
    input_file=$1
    output_file=$2
    old_password=$3
    new_password=$4
    qpdf --decrypt --password="$old_password" --encrypt "$new_password" "$new_password" 256 -- "$input_file" "$output_file"
    if [ $? -eq 0 ]; then
        echo -e "${GREEN}Kunci file berhasil diubah: $output_file${NC}"
    else
        echo -e "${RED}Gagal Mengubah Kunci File${NC}"
    fi
}

# program main
echo "╔══════════════════════════════════════╗"
echo "║             Dibuat Oleh              ║"
echo "╠══════════════════════════════════════╣"
echo "║ Nama  : Taufik Dimas Edystara        ║"
echo "║ NIM   : 2341720062                   ║"
echo "║ Kelas : TI-1B D-IV Teknik Informatika║"
echo "╚══════════════════════════════════════╝"
while true; do
    show_menu
    read -p ">>> Masukkan Pilihan (0-12) :" pilihan
    case $pilihan in
        1)
            read -p "Masukkan nama file Word: " input_file
            convert_to_pdf "$input_file" "pdf"
            ;;
        2)
            read -p "Masukkan nama file PDF: " input_file
            read -p "Masukkan nama file output Word: " output_file
            convert_pdf_to_word "$input_file" "$output_file"
            ;;
        3)
            read -p "Masukkan nama file PPT: " input_file
            convert_to_pdf "$input_file" "pdf"
            ;;
        4)
            read -p "Masukkan nama file PDF: " input_file
            read -p "Masukkan nama file output PPT: " output_file
            convert_pdf_to_ppt "$input_file" "$output_file"
            ;;
        5)
            read -p "Masukkan nama file Excel (xlsx): " input_file
            convert_to_pdf "$input_file" "pdf"
            ;;
        6)
            read -p "Masukkan nama file JPG: " input_file
            convert_to_pdf "$input_file" "pdf"
            ;;
        7)
            read -p "Masukkan nama file output PDF: " output_file
            read -p "Masukkan file PDF yang akan digabungkan (pisahkan dengan spasi): " input_files
            merge_pdfs "$output_file" $input_files
            ;;
        8)
            read -p "Masukkan nama file PDF: " input_file
            read -p "Masukkan pola output file (-%d.pdf): " output_pattern
            split_pdf "$input_file" "$output_pattern"
            ;;
        9)
            read -p "Masukkan nama file PDF: " input_file
            read -p "Masukkan nama file output PDF: " output_file
            compress_pdf "$input_file" "$output_file"
            ;;
        10)
            read -p "Masukkan nama file PDF: " input_file
            read -p "Masukkan nama file output PDF: " output_file
            read -sp "Masukkan password untuk mengunci file: " password
            echo
            lock_pdf "$input_file" "$output_file" "$password"
            ;;
        11)
            read -p "Masukkan nama file PDF: " input_file
            read -p "Masukkan nama file output PDF: " output_file
            read -sp "Masukkan password untuk membuka kunci file: " password
            echo
            unlock_pdf "$input_file" "$output_file" "$password"
            ;;
        12)
            read -p "Masukkan nama file PDF: " input_file
            read -p "Masukkan nama file output PDF: " output_file
            read -sp "Masukkan password lama: " old_password
            echo
            read -sp "Masukkan password baru: " new_password
            echo
            change_pdf_password "$input_file" "$output_file" "$old_password" "$new_password"
            ;;
        0)
            echo "Keluar..."
            exit 0
            ;;
        *)
        echo -e "${RED}Pilihan Tidak Valid${NC}"
            ;;
    esac
done