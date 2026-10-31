#!/bin/bash

# ==============================================================================
# HiFi BR Pro v4.0 — Multilingual Edition
# Creador de Imágenes ISO Blu-Ray Audio Hi-Res (BDMV)
# ==============================================================================

ROOT_DIR="$(pwd)"
TMP_DIR="$ROOT_DIR/.hifi_br_tmp"
OUTPUT_WAV_DIR="$TMP_DIR/wav_temp"
OUTPUT_VID_DIR="$TMP_DIR/vid_temp"
OUTPUT_BDMV_DIR="$ROOT_DIR/BLURAY_AUDIO_OUTPUT"
META_FILE="$TMP_DIR/mux_config.meta"
COMBINED_AUDIO="$TMP_DIR/album_full.wav"
ALBUM_VIDEO="$TMP_DIR/album_video.h264"
CLEAN_COVER_TEMP="$TMP_DIR/temp_cover_clean.bmp"
PAD_WAV="$TMP_DIR/pad.wav"
TSMUXER_LOG="$TMP_DIR/tsmuxer_error.log"
CONCAT_AUDIO_LIST="$TMP_DIR/concat_audio_list.txt"
LOCAL_TSMUXER="$HOME/.local/bin/tsmuxer"

# CÓDIGOS DE COLOR ANSI (ESTILO MATRIX)
COLOR_MATRIX="\033[1;92m"
COLOR_RESET="\033[0m"

# ==============================================================================
# SISTEMA DE LOCALIZACIÓN MULTI-IDIOMA (i18n)
# ==============================================================================
SYS_LANG=$(echo "${LANG:-en}" | cut -d'_' -f1 | tr '[:upper:]' '[:lower:]')

case "$SYS_LANG" in
    ca) # CATALÀ
        L_TITLE="💿 HiFi BR Pro — Creador d'ISO Blu-Ray Audio (v4.0 Final)"
        L_HELP_USE="Ús: ./hifi_br_pro.sh [OPCIÓ]"
        L_HELP_REQ="Requisits:"
        L_ERR_DEP="❌ ERROR: La següent eina no està instal·lada o no està al PATH:"
        L_ERR_TSMUXER="❌ ERROR: tsMuxeR no s'ha trobat ni al PATH ni a"
        L_DEP_MSG="Si us plau, instal·la les dependències i torna-ho a intentar."
        L_HZ_TITLE="1. Selecciona la qualitat d'àudio:"
        L_HZ_OPT1="  1) 48 kHz  (Estàndard / Ocupa menys espai)"
        L_HZ_OPT2="  2) 96 kHz  (Alta Fidelitat) [Per Defecte]"
        L_HZ_OPT3="  3) 192 kHz (Màxima Qualitat Studio)"
        L_HZ_PROMPT="Opció [1-3] (ENTER per a 96 kHz): "
        L_NORM_TITLE="2. Vols nivelar el volum entre pistes?"
        L_NORM_OPT1="  1) Conservar dinàmica original [Per Defecte]"
        L_NORM_OPT2="  2) Nivelar volum entre pistes (EBU R128)"
        L_NORM_PROMPT="Opció [1-2] (ENTER per a Original): "
        L_NORM_ACT="Activada (EBU R128)"
        L_NORM_DES="Desactivada (Sense canvis)"
        L_ISO_TITLE="3. Nom del fitxer ISO final:"
        L_ISO_PROMPT="Introdueix el nom (ENTER per a 'bluray_audio'): "
        L_ERR_COVER_MISSING="❌ ERROR: No s'ha trobat cap imatge de portada (cover.jpg/png)."
        L_ERR_COVER_SMALL="❌ ERROR: La portada és massa petita. Mínim 1080px."
        L_ERR_NO_TRACKS="❌ ERROR: No hi ha fitxers d'àudio vàlids en aquesta carpeta."
        L_ERR_SPACE="❌ ERROR: Espai en disc insuficient."
        L_RESUME_TITLE="📋 RESUM I ORDRE NUMÈRIC DE LA COMPILACIÓ"
        L_RESUME_TRACKS="🎵 Pistes trobades:"
        L_RESUME_AUDIO="🔊 Format sortida PCM: 24-bit /"
        L_RESUME_VIDEO="🎞️  Vídeo codificat: H.264 HD (Portada Estàtica Neta)"
        L_RESUME_COVER="📸 Portada:"
        L_RESUME_ISO="📁 Fitxer ISO:"
        L_RESUME_SIZE="📊 Mida est.: ~"
        L_RESUME_DISC="💿 Disc recomanat:"
        L_RESUME_SPACE="💾 Espai lliure verificat: OK"
        L_CONFIRM="Vols continuar? [S/n]: "
        L_CANCEL="🛑 Cancel·lat per l'usuari."
        L_STEP1="🎵 1/3 Processant pistes d'àudio..."
        L_DIRECT_COPY="  ⚡ [Pista %d/%d] Còpia directa: '%s'"
        L_CONVERTING="  🔄 [Pista %d/%d] Convertint a %s: '%s'"
        L_JOINING="  🔀 Unint pistes d'àudio..."
        L_JOIN_OK="  ✔ [100% OK] Pistes d'àudio unides correctament."
        L_ERR_AUDIO_COMB="❌ ERROR CRÍTICO: No s'ha pogut generar la pista d'àudio combinada."
        L_STEP2="🖼️  2/3 Renderitzant vídeo H.264 continu..."
        L_PRE_COVER="  🎨 Pre-convertint portada a RGB24..."
        L_VIDEO_PROGRESS="Codificant vídeo únic H.264"
        L_VIDEO_OK="  ✔ [100% OK] Renderitzat de vídeo H.264 completat."
        L_ERR_VIDEO="❌ ERROR CRÍTICO: Ha fallat la creació del vídeo H.264."
        L_STEP3="📀 3/3 Generant autoria Blu-ray HDMV..."
        L_BDMV_PROGRESS="Autoria BDMV"
        L_BDMV_OK="  ✔ [100% OK] Estructura BDMV generada correctament."
        L_ERR_TSMUXER_EXEC="❌ ERROR: Ha fallat la creació de BDMV a tsMuxeR."
        L_ISO_PROGRESS="Empaquetant ISO"
        L_SUCCESS_TITLE="🎉 PROCES COMPLETAT AMB ÈXIT!"
        L_SUCCESS_ISO="📁 Fitxer ISO a punt:"
        L_SUCCESS_DISC="💡 Suport recomanat:"
        L_ERR_ISO="❌ ERROR: No s'ha pogut crear el fitxer ISO."
        L_ENTER_EXIT="Prem ENTER per sortir..."
        L_YES_MATCH="^[SsYy]$"
        ;;
    eu) # EUSKARA
        L_TITLE="💿 HiFi BR Pro — Blu-Ray Audio ISO Sortzailea (v4.0 Final)"
        L_HELP_USE="Erabilera: ./hifi_br_pro.sh [AUKERA]"
        L_HELP_REQ="Betekizunak:"
        L_ERR_DEP="❌ ERROREA: Ondorengo tresna ez dago instalatuta edo ez dago PATHean:"
        L_ERR_TSMUXER="❌ ERROREA: tsMuxeR ez da aurkitu PATHean ezta hemen ere:"
        L_DEP_MSG="Mesedez, instalatu beharrezko tresnak eta saiatu berriro."
        L_HZ_TITLE="1. Hautatu audioaren kalitatea:"
        L_HZ_OPT1="  1) 48 kHz  (Estandarra / Leku gutxiago hartzen du)"
        L_HZ_OPT2="  2) 96 kHz  (Fidelitate Altua) [Berezkoa]"
        L_HZ_OPT3="  3) 192 kHz (Estudioko Gehienezko Kalitatea)"
        L_HZ_PROMPT="Aukera [1-3] (ENTER 96 kHz-erako): "
        L_NORM_TITLE="2. Abestien arteko bolumena berdindu nahi duzu?"
        L_NORM_OPT1="  1) Jatorrizko dinamika mantendu [Berezkoa]"
        L_NORM_OPT2="  2) Bolumena berdindu (EBU R128)"
        L_NORM_PROMPT="Aukera [1-2] (ENTER Jatorrizkorako): "
        L_NORM_ACT="Aktibatuta (EBU R128)"
        L_NORM_DES="Desaktibatuta (Aldaketarik gabe)"
        L_ISO_TITLE="3. Amaierako ISO fitxategiaren izena:"
        L_ISO_PROMPT="Sartu izena (ENTER 'bluray_audio'-rako): "
        L_ERR_COVER_MISSING="❌ ERROREA: Ez da azaleko irudirik aurkitu (cover.jpg/png)."
        L_ERR_COVER_SMALL="❌ ERROREA: Azaleko irudia txikiegia da. Gutxienez 1080px."
        L_ERR_NO_TRACKS="❌ ERROREA: Ez dago audio fitxategi baliozkorik karpeta honetan."
        L_ERR_SPACE="❌ ERROREA: Ez dago nahikoa lekurik diskoan."
        L_RESUME_TITLE="📋 BILDUMAREN LABURPENA ETA ORDENA NUMERIKOA"
        L_RESUME_TRACKS="🎵 Aurkitutako abestiak:"
        L_RESUME_AUDIO="🔊 PCM irteera formatua: 24-bit /"
        L_RESUME_VIDEO="🎞️  Kodifikatutako bideoa: H.264 HD (Azal Estatiko Garbia)"
        L_RESUME_COVER="📸 Azala:"
        L_RESUME_ISO="📁 ISO fitxategia:"
        L_RESUME_SIZE="📊 Gutxi gorabeherako tamaina: ~"
        L_RESUME_DISC="💿 Gomendatutako diskoa:"
        L_RESUME_SPACE="💾 Disko lekua egiaztatua: OK"
        L_CONFIRM="Jarraitu nahi duzu? [B/e]: "
        L_CANCEL="🛑 Erabiltzaileak bertan behera utzita."
        L_STEP1="🎵 1/3 Audio abestiak prozesatzen..."
        L_DIRECT_COPY="  ⚡ [Abestia %d/%d] Kopiatze zuzena: '%s'"
        L_CONVERTING="  🔄 [Abestia %d/%d] %s-ra bihurtzen: '%s'"
        L_JOINING="  🔀 Audio abestiak elkartzen..."
        L_JOIN_OK="  ✔ [100% OK] Audio abestiak ondo elkartu dira."
        L_ERR_AUDIO_COMB="❌ ERROE LARRIA: Ezin izan da audio pista konbinatua sortu."
        L_STEP2="🖼️  2/3 H.264 bideo jarraitua errendatzen..."
        L_PRE_COVER="  🎨 Azala RGB24-ra aurretik bihurtzen..."
        L_VIDEO_PROGRESS="H.264 bideo bakarra kodifikatzen"
        L_VIDEO_OK="  ✔ [100% OK] H.264 bideo errendatzea osatuta."
        L_ERR_VIDEO="❌ ERROE LARRIA: H.264 bideoaren sorkuntzak huts egin du."
        L_STEP3="📀 3/3 Blu-ray HDMV egiletza sortzen..."
        L_BDMV_PROGRESS="BDMV egiletza"
        L_BDMV_OK="  ✔ [100% OK] BDMV egitura sortuta."
        L_ERR_TSMUXER_EXEC="❌ ERROREA: BDMV sorkuntzak huts egin du tsMuxeR-en."
        L_ISO_PROGRESS="ISO paketatzen"
        L_SUCCESS_TITLE="🎉 PROZESUA ONERDO OSATU DA!"
        L_SUCCESS_ISO="📁 Prest dagoen ISO fitxategia:"
        L_SUCCESS_DISC="💡 Gomendatutako euskarria:"
        L_ERR_ISO="❌ ERROREA: Ezin izan da ISO fitxategia sortu."
        L_ENTER_EXIT="Sakatuko ENTER ateratzeko..."
        L_YES_MATCH="^[BbSsYy]$"
        ;;
    gl) # GALEGO
        L_TITLE="💿 HiFi BR Pro — Creador de ISO Blu-Ray Audio (v4.0 Final)"
        L_HELP_USE="Uso: ./hifi_br_pro.sh [OPCIÓN]"
        L_HELP_REQ="Requisitos:"
        L_ERR_DEP="❌ ERRO: A seguinte ferramenta non está instalada ou non está no PATH:"
        L_ERR_TSMUXER="❌ ERRO: tsMuxeR non se atopou nin no PATH nin en"
        L_DEP_MSG="Por favor, instala as ferramentas necesarias e téntao de novo."
        L_HZ_TITLE="1. Selecciona a calidade de audio:"
        L_HZ_OPT1="  1) 48 kHz  (Estándar / Ocupa menos espazo)"
        L_HZ_OPT2="  2) 96 kHz  (Alta Fidelidade) [Por Defecto]"
        L_HZ_OPT3="  3) 192 kHz (Máxima Calidade Studio)"
        L_HZ_PROMPT="Opción [1-3] (ENTER para 96 kHz): "
        L_NORM_TITLE="2. Queres nivelar o volume entre pistas?"
        L_NORM_OPT1="  1) Conservar dinámica orixinal [Por Defecto]"
        L_NORM_OPT2="  2) Nivelar volume entre pistas (EBU R128)"
        L_NORM_PROMPT="Opción [1-2] (ENTER para Orixinal): "
        L_NORM_ACT="Activada (EBU R128)"
        L_NORM_DES="Desactivada (Sen cambios)"
        L_ISO_TITLE="3. Nome do arquivo ISO final:"
        L_ISO_PROMPT="Introduce o nome (ENTER para 'bluray_audio'): "
        L_ERR_COVER_MISSING="❌ ERRO: Non se atopou ningunha imaxe de portada (cover.jpg/png)."
        L_ERR_COVER_SMALL="❌ ERRO: A portada é demasiado pequena. Mínimo 1080px."
        L_ERR_NO_TRACKS="❌ ERRO: Non hai arquivos de audio válidos nesta carpeta."
        L_ERR_SPACE="❌ ERRO: Espazo en disco insuficiente."
        L_RESUME_TITLE="📋 RESUMO E ORDE NUMÉRICA DA COMPILACIÓN"
        L_RESUME_TRACKS="🎵 Pistas atopadas:"
        L_RESUME_AUDIO="🔊 Formato saída PCM: 24-bit /"
        L_RESUME_VIDEO="🎞️  Vídeo codificado: H.264 HD (Portada Estática Limpa)"
        L_RESUME_COVER="📸 Portada:"
        L_RESUME_ISO="📁 Arquivo ISO:"
        L_RESUME_SIZE="📊 Tamaño est.: ~"
        L_RESUME_DISC="💿 Disco recomendado:"
        L_RESUME_SPACE="💾 Espazo libre verificado: OK"
        L_CONFIRM="Desexas continuar? [S/n]: "
        L_CANCEL="🛑 Cancelado polo usuario."
        L_STEP1="🎵 1/3 Procesando pistas de audio..."
        L_DIRECT_COPY="  ⚡ [Pista %d/%d] Copia directa: '%s'"
        L_CONVERTING="  🔄 [Pista %d/%d] Convertendo a %s: '%s'"
        L_JOINING="  🔀 Unindo pistas de audio..."
        L_JOIN_OK="  ✔ [100% OK] Pistas de audio unidas correctamente."
        L_ERR_AUDIO_COMB="❌ ERRO CRÍTICO: Non se puido xerar a pista de audio combinada."
        L_STEP2="🖼️  2/3 Renderizando vídeo H.264 continuo..."
        L_PRE_COVER="  🎨 Pre-convertendo portada a RGB24..."
        L_VIDEO_PROGRESS="Codificando vídeo único H.264"
        L_VIDEO_OK="  ✔ [100% OK] Renderizado de vídeo H.264 completado."
        L_ERR_VIDEO="❌ ERRO CRÍTICO: Fallou a creación do vídeo H.264."
        L_STEP3="📀 3/3 Xerando autoría Blu-ray HDMV..."
        L_BDMV_PROGRESS="Autoría BDMV"
        L_BDMV_OK="  ✔ [100% OK] Estructura BDMV xerada correctamente."
        L_ERR_TSMUXER_EXEC="❌ ERRO: Fallou a creación de BDMV en tsMuxeR."
        L_ISO_PROGRESS="Empaquetando ISO"
        L_SUCCESS_TITLE="🎉 PROCESO COMPLETADO CON ÉXITO!"
        L_SUCCESS_ISO="📁 Arquivo ISO listo:"
        L_SUCCESS_DISC="💡 Soporte recomendado:"
        L_ERR_ISO="❌ ERRO: Non se puido crear o arquivo ISO."
        L_ENTER_EXIT="Preme ENTER para finalizar..."
        L_YES_MATCH="^[SsYy]$"
        ;;
    pt) # PORTUGUÊS
        L_TITLE="💿 HiFi BR Pro — Criador de ISO Blu-Ray Audio (v4.0 Final)"
        L_HELP_USE="Uso: ./hifi_br_pro.sh [OPÇÃO]"
        L_HELP_REQ="Requisitos:"
        L_ERR_DEP="❌ ERRO: A seguinte ferramenta não está instalada ou não está no PATH:"
        L_ERR_TSMUXER="❌ ERRO: tsMuxeR não foi encontrado no PATH nem em"
        L_DEP_MSG="Por favor, instale as ferramentas necessárias e tente novamente."
        L_HZ_TITLE="1. Selecione a qualidade de áudio:"
        L_HZ_OPT1="  1) 48 kHz  (Padrão / Ocupa menos espaço)"
        L_HZ_OPT2="  2) 96 kHz  (Alta Fidelidade) [Padrão]"
        L_HZ_OPT3="  3) 192 kHz (Máxima Qualidade Studio)"
        L_HZ_PROMPT="Opção [1-3] (ENTER para 96 kHz): "
        L_NORM_TITLE="2. Deseja nivelar o volume entre as faixas?"
        L_NORM_OPT1="  1) Manter dinâmica original [Padrão]"
        L_NORM_OPT2="  2) Nivelar volume entre faixas (EBU R128)"
        L_NORM_PROMPT="Opção [1-2] (ENTER para Original): "
        L_NORM_ACT="Ativada (EBU R128)"
        L_NORM_DES="Desativada (Sem alterações)"
        L_ISO_TITLE="3. Nome do arquivo ISO final:"
        L_ISO_PROMPT="Digite o nome (ENTER para 'bluray_audio'): "
        L_ERR_COVER_MISSING="❌ ERRO: Nenhuma imagem de capa encontrada (cover.jpg/png)."
        L_ERR_COVER_SMALL="❌ ERRO: A imagem de capa é muito pequena. Mínimo 1080px."
        L_ERR_NO_TRACKS="❌ ERRO: Nenhum arquivo de áudio válido encontrado nesta pasta."
        L_ERR_SPACE="❌ ERRO: Espaço em disco insuficiente."
        L_RESUME_TITLE="📋 RESUMO E ORDEM NUMÉRICA DA COMPILAÇÃO"
        L_RESUME_TRACKS="🎵 Faixas encontradas:"
        L_RESUME_AUDIO="🔊 Formato de saída PCM: 24-bit /"
        L_RESUME_VIDEO="🎞️  Vídeo codificado: H.264 HD (Capa Estática Limpa)"
        L_RESUME_COVER="📸 Capa:"
        L_RESUME_ISO="📁 Arquivo ISO:"
        L_RESUME_SIZE="📊 Tamanho est.: ~"
        L_RESUME_DISC="💿 Disco recomendado:"
        L_RESUME_SPACE="💾 Espaço livre verificado: OK"
        L_CONFIRM="Deseja continuar? [S/n]: "
        L_CANCEL="🛑 Cancelado pelo usuário."
        L_STEP1="🎵 1/3 Processando faixas de áudio..."
        L_DIRECT_COPY="  ⚡ [Faixa %d/%d] Cópia direta: '%s'"
        L_CONVERTING="  🔄 [Faixa %d/%d] Convertendo para %s: '%s'"
        L_JOINING="  🔀 Unindo faixas de áudio..."
        L_JOIN_OK="  ✔ [100% OK] Faixas de áudio unidas com sucesso."
        L_ERR_AUDIO_COMB="❌ ERRO CRÍTICO: Não foi possível gerar a faixa de áudio combinada."
        L_STEP2="🖼️  2/3 Renderizando vídeo H.264 contínuo..."
        L_PRE_COVER="  🎨 Pré-convertendo capa para RGB24..."
        L_VIDEO_PROGRESS="Codificando vídeo único H.264"
        L_VIDEO_OK="  ✔ [100% OK] Renderização de vídeo H.264 concluída."
        L_ERR_VIDEO="❌ ERRO CRÍTICO: Falha na criação do vídeo H.264."
        L_STEP3="📀 3/3 Gerando autoria Blu-ray HDMV..."
        L_BDMV_PROGRESS="Autoria BDMV"
        L_BDMV_OK="  ✔ [100% OK] Estrutura BDMV gerada com sucesso."
        L_ERR_TSMUXER_EXEC="❌ ERRO: Falha na criação do BDMV no tsMuxeR."
        L_ISO_PROGRESS="Empacotando ISO"
        L_SUCCESS_TITLE="🎉 PROCESSO CONCLUÍDO COM SUCESSO!"
        L_SUCCESS_ISO="📁 Arquivo ISO pronto:"
        L_SUCCESS_DISC="💡 Mídia recomendada:"
        L_ERR_ISO="❌ ERRO: Não foi possível criar o arquivo ISO."
        L_ENTER_EXIT="Pressione ENTER para finalizar..."
        L_YES_MATCH="^[SsYy]$"
        ;;
    de) # DEUTSCH
        L_TITLE="💿 HiFi BR Pro — Blu-Ray Audio ISO-Ersteller (v4.0 Final)"
        L_HELP_USE="Verwendung: ./hifi_br_pro.sh [OPTION]"
        L_HELP_REQ="Anforderungen:"
        L_ERR_DEP="❌ FEHLER: Folgendes Tool ist nicht installiert oder nicht im PATH:"
        L_ERR_TSMUXER="❌ FEHLER: tsMuxeR wurde weder im PATH noch unter folgendem Pfad gefunden:"
        L_DEP_MSG="Bitte installieren Sie die erforderlichen Tools und versuchen Sie es erneut."
        L_HZ_TITLE="1. Wählen Sie die Audioqualität:"
        L_HZ_OPT1="  1) 48 kHz  (Standard / Benötigt weniger Speicherplatz)"
        L_HZ_OPT2="  2) 96 kHz  (High-Fidelity) [Standard]"
        L_HZ_OPT3="  3) 192 kHz (Maximale Studio-Qualität)"
        L_HZ_PROMPT="Option [1-3] (ENTER für 96 kHz): "
        L_NORM_TITLE="2. Lautstärke zwischen den Titeln anpassen?"
        L_NORM_OPT1="  1) Originaldynamik beibehalten [Standard]"
        L_NORM_OPT2="  2) Lautstärke anpassen (EBU R128)"
        L_NORM_PROMPT="Option [1-2] (ENTER für Original): "
        L_NORM_ACT="Aktiviert (EBU R128)"
        L_NORM_DES="Deaktiviert (Keine Änderungen)"
        L_ISO_TITLE="3. Name der finalen ISO-Datei:"
        L_ISO_PROMPT="Name eingeben (ENTER für 'bluray_audio'): "
        L_ERR_COVER_MISSING="❌ FEHLER: Kein Cover-Bild gefunden (cover.jpg/png)."
        L_ERR_COVER_SMALL="❌ FEHLER: Das Cover-Bild ist zu klein. Mindestens 1080px."
        L_ERR_NO_TRACKS="❌ FEHLER: Keine gültigen Audiodateien in diesem Ordner gefunden."
        L_ERR_SPACE="❌ FEHLER: Unzureichender Speicherplatz auf der Festplatte."
        L_RESUME_TITLE="📋 ZUSAMMENFASSUNG UND NUMERISCHE REIHENFOLGE"
        L_RESUME_TRACKS="🎵 Gefundene Titel:"
        L_RESUME_AUDIO="🔊 PCM-Ausgabeformat: 24-bit /"
        L_RESUME_VIDEO="🎞️  Codiertes Video: H.264 HD (Sauberes statisches Cover)"
        L_RESUME_COVER="📸 Cover:"
        L_RESUME_ISO="📁 ISO-Datei:"
        L_RESUME_SIZE="📊 Geschätzte Größe: ~"
        L_RESUME_DISC="💿 Empfohlene Disc:"
        L_RESUME_SPACE="💾 Freier Speicherplatz überprüft: OK"
        L_CONFIRM="Möchten Sie fortfahren? [J/n]: "
        L_CANCEL="🛑 Vom Benutzer abgebrochen."
        L_STEP1="🎵 1/3 Audiodateien werden verarbeitet..."
        L_DIRECT_COPY="  ⚡ [Titel %d/%d] Direktes Kopieren: '%s'"
        L_CONVERTING="  🔄 [Titel %d/%d] Konvertierung nach %s: '%s'"
        L_JOINING="  🔀 Zusammenfügen der Audiodateien..."
        L_JOIN_OK="  ✔ [100% OK] Audiodateien erfolgreich zusammengefügt."
        L_ERR_AUDIO_COMB="❌ KRITISCHER FEHLER: Die kombinierte Tonspur konnte nicht erstellt werden."
        L_STEP2="🖼️  2/3 Kontinuierliches H.264-Video wird gerendert..."
        L_PRE_COVER="  🎨 Vorkonvertierung des Covers nach RGB24..."
        L_VIDEO_PROGRESS="H.264-Einzelvideo wird codiert"
        L_VIDEO_OK="  ✔ [100% OK] H.264-Video-Rendering abgeschlossen."
        L_ERR_VIDEO="❌ KRITISCHER FEHLER: H.264-Videoerstellung fehlgeschlagen."
        L_STEP3="📀 3/3 Blu-ray HDMV-Authoring wird erstellt..."
        L_BDMV_PROGRESS="BDMV-Authoring"
        L_BDMV_OK="  ✔ [100% OK] BDMV-Struktur erfolgreich gerendert."
        L_ERR_TSMUXER_EXEC="❌ FEHLER: BDMV-Erstellung in tsMuxeR fehlgeschlagen."
        L_ISO_PROGRESS="ISO wird verpackt"
        L_SUCCESS_TITLE="🎉 PROZESS ERFOLGREICH ABGESCHLOSSEN!"
        L_SUCCESS_ISO="📁 Bereite ISO-Datei:"
        L_SUCCESS_DISC="💡 Empfohlenes Medium:"
        L_ERR_ISO="❌ FEHLER: ISO-Datei konnte nicht erstellt werden."
        L_ENTER_EXIT="Drücken Sie ENTER zum Beenden..."
        L_YES_MATCH="^[JjYySs]$"
        ;;
    fr) # FRANÇAIS
        L_TITLE="💿 HiFi BR Pro — Créateur d'ISO Blu-Ray Audio (v4.0 Final)"
        L_HELP_USE="Utilisation: ./hifi_br_pro.sh [OPTION]"
        L_HELP_REQ="Exigences:"
        L_ERR_DEP="❌ ERREUR: L'outil suivant n'est pas installé ou n'est pas dans le PATH:"
        L_ERR_TSMUXER="❌ ERREUR: tsMuxeR n'a pas été trouvé dans le PATH ni dans"
        L_DEP_MSG="Veuillez installer les outils nécessaires et réessayer."
        L_HZ_TITLE="1. Sélectionnez la qualité audio:"
        L_HZ_OPT1="  1) 48 kHz  (Standard / Prendre moins d'espace)"
        L_HZ_OPT2="  2) 96 kHz  (Haute Fidélité) [Par Défaut]"
        L_HZ_OPT3="  3) 192 kHz (Qualité Studio Maximale)"
        L_HZ_PROMPT="Option [1-3] (ENTER pour 96 kHz): "
        L_NORM_TITLE="2. Égaliser le volume entre les pistes?"
        L_NORM_OPT1="  1) Conserver la dynamique originale [Par Défaut]"
        L_NORM_OPT2="  2) Égaliser le volume entre les pistes (EBU R128)"
        L_NORM_PROMPT="Option [1-2] (ENTER pour Original): "
        L_NORM_ACT="Activée (EBU R128)"
        L_NORM_DES="Désactivée (Aucun changement)"
        L_ISO_TITLE="3. Nom du fichier ISO final:"
        L_ISO_PROMPT="Entrez le nom (ENTER pour 'bluray_audio'): "
        L_ERR_COVER_MISSING="❌ ERREUR: Aucune image de couverture trouvée (cover.jpg/png)."
        L_ERR_COVER_SMALL="❌ ERREUR: L'image de couverture est trop petite. Minimum 1080px."
        L_ERR_NO_TRACKS="❌ ERREUR: Aucun fichier audio valide trouvé dans ce dossier."
        L_ERR_SPACE="❌ ERREUR: Espace disque insuffisant."
        L_RESUME_TITLE="📋 RÉSUMÉ ET ORDRE NUMÉRIQUE DE LA COMPILATION"
        L_RESUME_TRACKS="🎵 Pistes trouvées:"
        L_RESUME_AUDIO="🔊 Format de sortie PCM: 24-bit /"
        L_RESUME_VIDEO="🎞️  Vidéo codée: H.264 HD (Couverture Statique Propre)"
        L_RESUME_COVER="📸 Couverture:"
        L_RESUME_ISO="📁 Fichier ISO:"
        L_RESUME_SIZE="📊 Taille est.: ~"
        L_RESUME_DISC="💿 Disque recommandé:"
        L_RESUME_SPACE="💾 Espace disque libre vérifié: OK"
        L_CONFIRM="Voulez-vous continuer? [O/n]: "
        L_CANCEL="🛑 Annulé par l'utilisateur."
        L_STEP1="🎵 1/3 Traitement des pistes audio..."
        L_DIRECT_COPY="  ⚡ [Piste %d/%d] Copie directe: '%s'"
        L_CONVERTING="  🔄 [Piste %d/%d] Conversion vers %s: '%s'"
        L_JOINING="  🔀 Fusion des pistes audio..."
        L_JOIN_OK="  ✔ [100% OK] Pistes audio fusionnées avec succès."
        L_ERR_AUDIO_COMB="❌ ERREUR CRITIQUE: Impossible de générer la piste audio combinée."
        L_STEP2="🖼️  2/3 Rendu de la vidéo H.264 continue..."
        L_PRE_COVER="  🎨 Pré-conversion de la couverture en RGB24..."
        L_VIDEO_PROGRESS="Encodage de la vidéo unique H.264"
        L_VIDEO_OK="  ✔ [100% OK] Rendu vidéo H.264 terminé."
        L_ERR_VIDEO="❌ ERREUR CRITIQUE: Échec de la création de la vidéo H.264."
        L_STEP3="📀 3/3 Génération de l'auteurie Blu-ray HDMV..."
        L_BDMV_PROGRESS="Auteurie BDMV"
        L_BDMV_OK="  ✔ [100% OK] Structure BDMV générée avec succès."
        L_ERR_TSMUXER_EXEC="❌ ERREUR: Échec de la création du BDMV dans tsMuxeR."
        L_ISO_PROGRESS="Emballage de l'ISO"
        L_SUCCESS_TITLE="🎉 PROCESSUS TERMINÉ AVEC SUCCÈS!"
        L_SUCCESS_ISO="📁 Fichier ISO prêt:"
        L_SUCCESS_DISC="💡 Support recommandé:"
        L_ERR_ISO="❌ ERREUR: Impossible de créer le fichier ISO."
        L_ENTER_EXIT="Appuyez sur ENTER pour terminer..."
        L_YES_MATCH="^[OoYySs]$"
        ;;
    it) # ITALIANO
        L_TITLE="💿 HiFi BR Pro — Creatore di ISO Blu-Ray Audio (v4.0 Final)"
        L_HELP_USE="Uso: ./hifi_br_pro.sh [OPZIONE]"
        L_HELP_REQ="Requisiti:"
        L_ERR_DEP="❌ ERRORE: Il seguente strumento non è installato o non è nel PATH:"
        L_ERR_TSMUXER="❌ ERRORE: tsMuxeR non è stato trovato nel PATH né in"
        L_DEP_MSG="Per favore, installa gli strumenti necessari e riprova."
        L_HZ_TITLE="1. Seleziona la qualità audio:"
        L_HZ_OPT1="  1) 48 kHz  (Standard / Occupa meno spazio)"
        L_HZ_OPT2="  2) 96 kHz  (Alta Fedeltà) [Predefinito]"
        L_HZ_OPT3="  3) 192 kHz (Massima Qualità Studio)"
        L_HZ_PROMPT="Opzione [1-3] (ENTER per 96 kHz): "
        L_NORM_TITLE="2. Livellare il volume tra le tracce?"
        L_NORM_OPT1="  1) Mantieni dinamica originale [Predefinito]"
        L_NORM_OPT2="  2) Livella volume tra le tracce (EBU R128)"
        L_NORM_PROMPT="Opzione [1-2] (ENTER per Originale): "
        L_NORM_ACT="Attivata (EBU R128)"
        L_NORM_DES="Disattivata (Nessuna modifica)"
        L_ISO_TITLE="3. Nome del file ISO finale:"
        L_ISO_PROMPT="Inserisci il nome (ENTER per 'bluray_audio'): "
        L_ERR_COVER_MISSING="❌ ERRORE: Nessuna immagine di copertina trovata (cover.jpg/png)."
        L_ERR_COVER_SMALL="❌ ERRORE: L'immagine di copertina è troppo piccola. Minimo 1080px."
        L_ERR_NO_TRACKS="❌ ERRORE: Nessun file audio valido trovato in questa cartella."
        L_ERR_SPACE="❌ ERRORE: Spazio su disco insufficiente."
        L_RESUME_TITLE="📋 RIEPILOGO E ORDINE NUMERICO DELLA COMPILAZIONE"
        L_RESUME_TRACKS="🎵 Tracce trovate:"
        L_RESUME_AUDIO="🔊 Formato uscita PCM: 24-bit /"
        L_RESUME_VIDEO="🎞️  Video codificato: H.264 HD (Copertina Statica Pulita)"
        L_RESUME_COVER="📸 Copertina:"
        L_RESUME_ISO="📁 File ISO:"
        L_RESUME_SIZE="📊 Dimensione stimata: ~"
        L_RESUME_DISC="💿 Disco consigliato:"
        L_RESUME_SPACE="💾 Spazio libero verificato: OK"
        L_CONFIRM="Vuoi continuare? [S/n]: "
        L_CANCEL="🛑 Annullato dall'utente."
        L_STEP1="🎵 1/3 Elaborazione delle tracce audio..."
        L_DIRECT_COPY="  ⚡ [Traccia %d/%d] Copia diretta: '%s'"
        L_CONVERTING="  🔄 [Traccia %d/%d] Conversione a %s: '%s'"
        L_JOINING="  🔀 Unione delle tracce audio..."
        L_JOIN_OK="  ✔ [100% OK] Tracce audio unite con successo."
        L_ERR_AUDIO_COMB="❌ ERRORE CRITICO: Impossibile generare la traccia audio combinata."
        L_STEP2="🖼️  2/3 Rendering del video H.264 continuo..."
        L_PRE_COVER="  🎨 Pre-conversione della copertina in RGB24..."
        L_VIDEO_PROGRESS="Codifica video singolo H.264"
        L_VIDEO_OK="  ✔ [100% OK] Rendering video H.264 completato."
        L_ERR_VIDEO="❌ ERRORE CRITICO: Creazione del video H.264 fallita."
        L_STEP3="📀 3/3 Generazione authoring Blu-ray HDMV..."
        L_BDMV_PROGRESS="Authoring BDMV"
        L_BDMV_OK="  ✔ [100% OK] Struttura BDMV generata con successo."
        L_ERR_TSMUXER_EXEC="❌ ERRORE: Creazione BDMV fallita in tsMuxeR."
        L_ISO_PROGRESS="Impacchettamento ISO"
        L_SUCCESS_TITLE="🎉 PROCESSO COMPLETATO CON SUCCESSO!"
        L_SUCCESS_ISO="📁 File ISO pronto:"
        L_SUCCESS_DISC="💡 Supporto consigliato:"
        L_ERR_ISO="❌ ERRORE: Impossibile creare il file ISO."
        L_ENTER_EXIT="Premi ENTER per uscire..."
        L_YES_MATCH="^[SsYy]$"
        ;;
    es) # CASTELLANO
        L_TITLE="💿 HiFi BR Pro — Creador de ISO Blu-Ray Audio (v4.0 Final)"
        L_HELP_USE="Uso: ./hifi_br_pro.sh [OPCIÓN]"
        L_HELP_REQ="Requisitos:"
        L_ERR_DEP="❌ ERROR: La siguiente herramienta no está instalada o no está en el PATH:"
        L_ERR_TSMUXER="❌ ERROR: tsMuxeR no se encuentra ni en PATH ni en"
        L_DEP_MSG="Por favor, instala las herramientas necesarias e inténtalo de nuevo."
        L_HZ_TITLE="1. Selecciona la calidad de audio:"
        L_HZ_OPT1="  1) 48 kHz  (Estándar / Ocupa menos espacio)"
        L_HZ_OPT2="  2) 96 kHz  (Alta Fidelidad) [Por Defecto]"
        L_HZ_OPT3="  3) 192 kHz (Máxima Calidad Studio)"
        L_HZ_PROMPT="Opción [1-3] (ENTER para 96 kHz): "
        L_NORM_TITLE="2. ¿Deseas nivelar el volumen entre pistas?"
        L_NORM_OPT1="  1) Conservar dinámica original [Por Defecto]"
        L_NORM_OPT2="  2) Nivelar volumen entre pistas (EBU R128)"
        L_NORM_PROMPT="Opción [1-2] (ENTER para Original): "
        L_NORM_ACT="Activada (EBU R128)"
        L_NORM_DES="Desactivada (Sin cambios)"
        L_ISO_TITLE="3. Nombre del archivo ISO final:"
        L_ISO_PROMPT="Introduce el nombre (ENTER para 'bluray_audio'): "
        L_ERR_COVER_MISSING="❌ ERROR: No se ha encontrado imagen de portada (cover.jpg/png)."
        L_ERR_COVER_SMALL="❌ ERROR: La portada es demasiado pequeña. Mínimo 1080px."
        L_ERR_NO_TRACKS="❌ ERROR: No hay archivos de audio válidos en esta carpeta."
        L_ERR_SPACE="❌ ERROR: Espacio en disco insuficiente."
        L_RESUME_TITLE="📋 RESUMEN Y ORDEN NUMÉRICO DE LA COMPILACIÓN"
        L_RESUME_TRACKS="🎵 Pistas encontradas:"
        L_RESUME_AUDIO="🔊 Formato salida PCM: 24-bit /"
        L_RESUME_VIDEO="🎞️  Vídeo codificado: H.264 HD (Portada Estática Limpia)"
        L_RESUME_COVER="📸 Portada:"
        L_RESUME_ISO="📁 Archivo ISO:"
        L_RESUME_SIZE="📊 Tamaño est.: ~"
        L_RESUME_DISC="💿 Disco recomendado:"
        L_RESUME_SPACE="💾 Espacio libre verificado: OK"
        L_CONFIRM="¿Deseas continuar? [S/n]: "
        L_CANCEL="🛑 Cancelado por el usuario."
        L_STEP1="🎵 1/3 Procesando pistas de audio..."
        L_DIRECT_COPY="  ⚡ [Pista %d/%d] Copia directa: '%s'"
        L_CONVERTING="  🔄 [Pista %d/%d] Convertida a %s: '%s'"
        L_JOINING="  🔀 Uniendo pistas de audio..."
        L_JOIN_OK="  ✔ [100% OK] Pistas de audio unidas correctamente."
        L_ERR_AUDIO_COMB="❌ ERROR CRÍTICO: No se pudo generar la pista de audio combinada."
        L_STEP2="🖼️  2/3 Renderizando vídeo H.264 continuo..."
        L_PRE_COVER="  🎨 Pre-convertiendo portada a RGB24..."
        L_VIDEO_PROGRESS="Codificando vídeo único H.264"
        L_VIDEO_OK="  ✔ [100% OK] Renderizado de vídeo H.264 completado."
        L_ERR_VIDEO="❌ ERROR CRÍTICO: Falló la creación del vídeo H.264."
        L_STEP3="📀 3/3 Generando autoría Blu-ray HDMV..."
        L_BDMV_PROGRESS="Autoría BDMV"
        L_BDMV_OK="  ✔ [100% OK] Estructura BDMV generada correctamente."
        L_ERR_TSMUXER_EXEC="❌ ERROR: Falló la creación de BDMV en tsMuxeR."
        L_ISO_PROGRESS="Empaquetando ISO"
        L_SUCCESS_TITLE="🎉 ¡PROCESO COMPLETADO CON ÉXITO!"
        L_SUCCESS_ISO="📁 Archivo ISO listo:"
        L_SUCCESS_DISC="💡 Soporte recomendado:"
        L_ERR_ISO="❌ ERROR: No se pudo crear el archivo ISO."
        L_ENTER_EXIT="Presiona ENTER para finalizar..."
        L_YES_MATCH="^[SsYy]$"
        ;;
    *) # ENGLISH (DEFAULT)
        L_TITLE="💿 HiFi BR Pro — Blu-Ray Audio ISO Creator (v4.0 Final)"
        L_HELP_USE="Usage: ./hifi_br_pro.sh [OPTION]"
        L_HELP_REQ="Requirements:"
        L_ERR_DEP="❌ ERROR: Tool is not installed or not in PATH:"
        L_ERR_TSMUXER="❌ ERROR: tsMuxeR was not found in PATH nor at"
        L_DEP_MSG="Please install the required tools and try again."
        L_HZ_TITLE="1. Select audio quality:"
        L_HZ_OPT1="  1) 48 kHz  (Standard / Smaller size)"
        L_HZ_OPT2="  2) 96 kHz  (High Fidelity) [Default]"
        L_HZ_OPT3="  3) 192 kHz (Maximum Studio Quality)"
        L_HZ_PROMPT="Option [1-3] (ENTER for 96 kHz): "
        L_NORM_TITLE="2. Normalize volume between tracks?"
        L_NORM_OPT1="  1) Keep original dynamic range [Default]"
        L_NORM_OPT2="  2) Normalize volume between tracks (EBU R128)"
        L_NORM_PROMPT="Option [1-2] (ENTER for Original): "
        L_NORM_ACT="Enabled (EBU R128)"
        L_NORM_DES="Disabled (Unchanged)"
        L_ISO_TITLE="3. Final ISO filename:"
        L_ISO_PROMPT="Enter filename (ENTER for 'bluray_audio'): "
        L_ERR_COVER_MISSING="❌ ERROR: Cover image not found (cover.jpg/png)."
        L_ERR_COVER_SMALL="❌ ERROR: Cover image is too small. Minimum 1080px."
        L_ERR_NO_TRACKS="❌ ERROR: No valid audio files found in this directory."
        L_ERR_SPACE="❌ ERROR: Insufficient disk space."
        L_RESUME_TITLE="📋 COMPILATION SUMMARY AND TRACK ORDER"
        L_RESUME_TRACKS="🎵 Tracks found:"
        L_RESUME_AUDIO="🔊 Output PCM format: 24-bit /"
        L_RESUME_VIDEO="🎞️  Encoded video: H.264 HD (Clean Static Cover)"
        L_RESUME_COVER="📸 Cover:"
        L_RESUME_ISO="📁 ISO file:"
        L_RESUME_SIZE="📊 Est. size: ~"
        L_RESUME_DISC="💿 Recommended disc:"
        L_RESUME_SPACE="💾 Free space verified: OK"
        L_CONFIRM="Do you want to continue? [Y/n]: "
        L_CANCEL="🛑 Cancelled by user."
        L_STEP1="🎵 1/3 Processing audio tracks..."
        L_DIRECT_COPY="  ⚡ [Track %d/%d] Direct copy: '%s'"
        L_CONVERTING="  🔄 [Track %d/%d] Converting to %s: '%s'"
        L_JOINING="  🔀 Joining audio tracks..."
        L_JOIN_OK="  ✔ [100% OK] Audio tracks joined successfully."
        L_ERR_AUDIO_COMB="❌ CRITICAL ERROR: Could not generate combined audio track."
        L_STEP2="🖼️  2/3 Rendering continuous H.264 video..."
        L_PRE_COVER="  🎨 Pre-converting cover to RGB24..."
        L_VIDEO_PROGRESS="Encoding single H.264 video"
        L_VIDEO_OK="  ✔ [100% OK] H.264 video rendering completed."
        L_ERR_VIDEO="❌ CRITICAL ERROR: H.264 video creation failed."
        L_STEP3="📀 3/3 Generating Blu-ray HDMV authoring..."
        L_BDMV_PROGRESS="BDMV authoring"
        L_BDMV_OK="  ✔ [100% OK] BDMV structure rendered successfully."
        L_ERR_TSMUXER_EXEC="❌ ERROR: BDMV creation failed in tsMuxeR."
        L_ISO_PROGRESS="Packaging ISO"
        L_SUCCESS_TITLE="🎉 PROCESS COMPLETED SUCCESSFULLY!"
        L_SUCCESS_ISO="📁 Ready ISO file:"
        L_SUCCESS_DISC="💡 Recommended media:"
        L_ERR_ISO="❌ ERROR: Could not create ISO file."
        L_ENTER_EXIT="Press ENTER to exit..."
        L_YES_MATCH="^[YySsOoJjBb]$"
        ;;
esac

# --- OPCIÓN DE AYUDA (-h / --help) ---
if [[ "$1" == "-h" || "$1" == "--help" ]]; then
    echo -e "${COLOR_MATRIX}=================================================="
    echo " $L_TITLE"
    echo "=================================================="
    echo -e "${COLOR_RESET}"
    echo "$L_HELP_USE"
    echo ""
    echo "$L_HELP_REQ"
    echo "  - ffmpeg, ffprobe, genisoimage, python3, tsmuxer"
    exit 0
fi

# --- VERIFICACIÓN DE DEPENDENCIAS ---
DEPENDENCIAS=("ffmpeg" "ffprobe" "genisoimage" "python3")
faltan_deps=false

for cmd in "${DEPENDENCIAS[@]}"; do
    if ! command -v "$cmd" &> /dev/null; then
        echo "$L_ERR_DEP '$cmd'"
        faltan_deps=true
    fi
done

# Verificar tsMuxeR
TSMUXER_CMD=""
if command -v tsmuxer &> /dev/null; then
    TSMUXER_CMD="tsmuxer"
elif [ -x "$LOCAL_TSMUXER" ]; then
    TSMUXER_CMD="$LOCAL_TSMUXER"
else
    echo "$L_ERR_TSMUXER '$LOCAL_TSMUXER'."
    faltan_deps=true
fi

if [ "$faltan_deps" = true ]; then
    echo ""
    echo "$L_DEP_MSG"
    read -p "$L_ENTER_EXIT"
    exit 1
fi

# --- TRAP DE LIMPIEZA AUTOMÁTICA ---
limpiar_temporales() {
    rm -rf "$TMP_DIR" "$OUTPUT_BDMV_DIR" 2>/dev/null
}
trap limpiar_temporales EXIT

dibujar_progreso_total() {
    local pct=$1
    local texto=$2
    
    [ "$pct" -gt 100 ] && pct=100
    
    local ancho_barra=25
    local llenos=$((pct * ancho_barra / 100))
    local vacios=$((ancho_barra - llenos))
    
    local barra=""
    [ $llenos -gt 0 ] && barra=$(printf '█%.0s' $(seq 1 $llenos))
    [ $vacios -gt 0 ] && barra="${barra}$(printf '░%.0s' $(seq 1 $vacios))"
    
    printf "\r\033[K ${COLOR_MATRIX}PROGRESS: [%s] %3d%% (%s)${COLOR_RESET}" "$barra" "$pct" "$texto"
}

limpiar_linea_progreso() {
    printf "\r\033[K"
}

obtener_bdr_recomendado() {
    local mb=$1
    if [ $mb -le 23800 ]; then
        echo "💿 BD-R Single Layer (25 GB)"
    elif [ $mb -le 47600 ]; then
        echo "💿 BD-R Dual Layer (50 GB)"
    else
        echo "💿 BD-R XL Triple/Quad Layer (100 GB / 128 GB)"
    fi
}

convertir_a_tiempo_capitulo() {
    local input_sec=$1
    python3 -c "
import sys
sec = float(sys.argv[1])
h = int(sec // 3600)
m = int((sec % 3600) // 60)
s = sec % 60
print(f'{h:02d}:{m:02d}:{s:06.3f}')
" "$input_sec"
}

echo -e "${COLOR_MATRIX}"
echo "=================================================="
echo " $L_TITLE"
echo "=================================================="
echo -e "${COLOR_RESET}"

limpiar_temporales
mkdir -p "$OUTPUT_WAV_DIR" "$OUTPUT_VID_DIR"

# 1. FRECUENCIA DE MUESTREO
echo ""
echo -e "${COLOR_MATRIX}$L_HZ_TITLE${COLOR_RESET}"
echo "$L_HZ_OPT1"
echo "$L_HZ_OPT2"
echo "$L_HZ_OPT3"
echo ""
read -p "$L_HZ_PROMPT" opcion_hz

case $opcion_hz in
    1) SAMPLE_RATE=48000; LABEL_HZ="48 kHz" ;;
    2|"") SAMPLE_RATE=96000; LABEL_HZ="96 kHz" ;;
    3) SAMPLE_RATE=192000; LABEL_HZ="192 kHz" ;;
    *) SAMPLE_RATE=96000; LABEL_HZ="96 kHz" ;;
esac

# 2. NORMALIZACIÓN
echo ""
echo -e "${COLOR_MATRIX}$L_NORM_TITLE${COLOR_RESET}"
echo "$L_NORM_OPT1"
echo "$L_NORM_OPT2"
echo ""
read -p "$L_NORM_PROMPT" opcion_norm

case $opcion_norm in
    2) NORM_AUDIO=true; LABEL_NORM="$L_NORM_ACT"; AUDIO_FILTER_OPT="-af loudnorm=I=-16:TP=-1.5:LRA=11" ;;
    *) NORM_AUDIO=false; LABEL_NORM="$L_NORM_DES"; AUDIO_FILTER_OPT="" ;;
esac

# 3. NOMBRE ISO
echo ""
echo -e "${COLOR_MATRIX}$L_ISO_TITLE${COLOR_RESET}"
read -p "$L_ISO_PROMPT" raw_iso_name

if [[ -z "$raw_iso_name" ]]; then
    CUSTOM_NAME="bluray_audio"
else
    CUSTOM_NAME=$(echo "$raw_iso_name" | sed 's/\.iso$//i' | sed 's/[^a-zA-Z0-9_-]/_/g')
fi

ISO_NAME="${CUSTOM_NAME}.iso"
VOLUME_LABEL=$(echo "$CUSTOM_NAME" | tr '[:lower:]' '[:upper:]' | cut -c1-32)

# 4. VALIDACIÓN DE PORTADA
COVER_IMAGE=""
shopt -s nullglob nocaseglob
for img in cover.{jpg,jpeg,png,webp,bmp}; do
    if [[ -f "$img" ]]; then COVER_IMAGE="$img"; break; fi
done
shopt -u nullglob nocaseglob

if [[ -z "$COVER_IMAGE" ]]; then
    echo "$L_ERR_COVER_MISSING"
    read -p "$L_ENTER_EXIT"
    exit 1
fi

WIDTH=$(ffprobe -v error -select_streams v:0 -show_entries stream=width -of default=nw=1:nk=1 "$COVER_IMAGE")
HEIGHT=$(ffprobe -v error -select_streams v:0 -show_entries stream=height -of default=nw=1:nk=1 "$COVER_IMAGE")

if [ "$WIDTH" -lt 1080 ] || [ "$HEIGHT" -lt 1080 ]; then
    echo "$L_ERR_COVER_SMALL (${WIDTH}x${HEIGHT})."
    read -p "$L_ENTER_EXIT"
    exit 1
fi

ESTADO_PORTADA="'$COVER_IMAGE' (${WIDTH}x${HEIGHT})"

# 5. PISTAS DE AUDIO
EXTENSIONS=("flac" "wav" "m4a" "alac" "ape" "aiff" "mp3" "ogg" "opus")
archivos_encontrados=()

shopt -s nullglob nocaseglob
for ext in "${EXTENSIONS[@]}"; do
    for file in *."$ext"; do
        if [[ -f "$file" ]]; then
            if [[ "$file" != "album_full.wav" ]]; then
                archivos_encontrados+=("$file")
            fi
        fi
    done
done
shopt -u nullglob nocaseglob

IFS=$'\n' wav_files=($(printf "%s\n" "${archivos_encontrados[@]}" | sort -V))
unset IFS

total_pistas=${#wav_files[@]}
if [ $total_pistas -eq 0 ]; then
    echo "$L_ERR_NO_TRACKS"
    read -p "$L_ENTER_EXIT"
    exit 1
fi

TOTAL_SEC_ESTIMADO=0
for f in "${wav_files[@]}"; do
    dur=$(ffprobe -v error -show_entries format=duration -of default=noprint_wrappers=1:nokey=1 "$f" 2>/dev/null || echo 0)
    TOTAL_SEC_ESTIMADO=$(python3 -c "print($TOTAL_SEC_ESTIMADO + $dur)")
done

BYTES_AUDIO_SEC=$(( (SAMPLE_RATE * 24 * 2) / 8 ))
BYTES_VIDEO_SEC=400000 
BYTES_TOTAL_SEC=$((BYTES_AUDIO_SEC + BYTES_VIDEO_SEC))

BYTES_ESTIMADOS=$(python3 -c "print(int($TOTAL_SEC_ESTIMADO * $BYTES_TOTAL_SEC))")
MB_ESTIMADOS=$((BYTES_ESTIMADOS / 1024 / 1024))

if [ $MB_ESTIMADOS -ge 1024 ]; then
    SIZE_EST_HUMAN=$(awk -v b="$BYTES_ESTIMADOS" 'BEGIN {printf "%.2f GB", b/1024/1024/1024}')
else
    SIZE_EST_HUMAN="${MB_ESTIMADOS} MB"
fi

DISCO_ESTIMADO=$(obtener_bdr_recomendado $MB_ESTIMADOS)
DURACION_MIN=$(python3 -c "print(int($TOTAL_SEC_ESTIMADO // 60))")

# COMPROBACIÓN ESPACIO EN DISCO
ESPACIO_LIBRE_KB=$(df -k "$ROOT_DIR" | awk 'NR==2 {print $4}')
ESPACIO_LIBRE_MB=$((ESPACIO_LIBRE_KB / 1024))
ESPACIO_NECESARIO_MB=$((MB_ESTIMADOS * 25 / 10))

if [ $ESPACIO_LIBRE_MB -lt $ESPACIO_NECESARIO_MB ]; then
    LIBRE_HUMAN=$(python3 -c "print(f'{$ESPACIO_LIBRE_MB/1024:.2f} GB')")
    NECESARIO_HUMAN=$(python3 -c "print(f'{$ESPACIO_NECESARIO_MB/1024:.2f} GB')")
    echo ""
    echo "$L_ERR_SPACE"
    echo "   Available: $LIBRE_HUMAN | Required: $NECESARIO_HUMAN"
    read -p "$L_ENTER_EXIT"
    exit 1
fi

echo ""
echo -e "${COLOR_MATRIX}=================================================="
echo " $L_RESUME_TITLE"
echo "=================================================="
echo "$L_RESUME_TRACKS $total_pistas (~$DURACION_MIN min)"
echo "$L_RESUME_AUDIO $LABEL_HZ"
echo "$L_RESUME_VIDEO"
echo "$L_RESUME_COVER $ESTADO_PORTADA"
echo "$L_RESUME_ISO $ISO_NAME"
echo "$L_RESUME_SIZE$SIZE_EST_HUMAN"
echo "$L_RESUME_DISC $DISCO_ESTIMADO"
echo "$L_RESUME_SPACE"
echo -e "==================================================${COLOR_RESET}"
echo ""
read -p "$L_CONFIRM" confirmacion
if [[ -n "$confirmacion" && ! "$confirmacion" =~ $L_YES_MATCH ]]; then
    echo "$L_CANCEL"
    exit 0
fi

# 7. PROCESAR AUDIO
echo ""
echo -e "${COLOR_MATRIX}$L_STEP1${COLOR_RESET}"

ffmpeg -hide_banner -loglevel error -y -f lavfi -i "anullsrc=r=$SAMPLE_RATE:cl=stereo" -t 0.5 -c:a pcm_s24le "$PAD_WAV"

> "$CONCAT_AUDIO_LIST"
echo "file '$PAD_WAV'" >> "$CONCAT_AUDIO_LIST"

actual=0
acumulado_sec=0.5
CHAPTERS_LIST="00:00:00.500"

for file in "${wav_files[@]}"; do
    filename=$(basename "$file")
    filename_no_ext="${filename%.*}"
    out_wav="$OUTPUT_WAV_DIR/${filename_no_ext}.wav"
    
    actual=$((actual + 1))
    tc=$(convertir_a_tiempo_capitulo "$acumulado_sec")
    if [ $actual -gt 1 ]; then CHAPTERS_LIST="$CHAPTERS_LIST;$tc"; fi
    
    src_codec=$(ffprobe -v error -select_streams a:0 -show_entries stream=codec_name -of default=nw=1:nk=1 "$file" 2>/dev/null)
    src_sample=$(ffprobe -v error -select_streams a:0 -show_entries stream=sample_rate -of default=nw=1:nk=1 "$file" 2>/dev/null)
    
    if [ "$NORM_AUDIO" = false ] && [ "$src_codec" = "pcm_s24le" ] && [ "$src_sample" = "$SAMPLE_RATE" ]; then
        cp "$file" "$out_wav"
        printf "$L_DIRECT_COPY ${COLOR_MATRIX}✔ [100%% OK]${COLOR_RESET}\n" "$actual" "$total_pistas" "$filename"
    else
        ffmpeg -hide_banner -loglevel error -y -i "$file" $AUDIO_FILTER_OPT -c:a pcm_s24le -ar "$SAMPLE_RATE" "$out_wav"
        printf "$L_CONVERTING ${COLOR_MATRIX}✔ [100%% OK]${COLOR_RESET}\n" "$actual" "$total_pistas" "$LABEL_HZ" "$filename"
    fi
    
    dur_pista=$(ffprobe -v error -show_entries format=duration -of default=noprint_wrappers=1:nokey=1 "$out_wav" 2>/dev/null || echo 0)
    acumulado_sec=$(python3 -c "print($acumulado_sec + $dur_pista)")
    
    echo "file '$out_wav'" >> "$CONCAT_AUDIO_LIST"
done

echo -e "${COLOR_MATRIX}$L_JOINING${COLOR_RESET}"
ffmpeg -hide_banner -loglevel error -f concat -safe 0 -i "$CONCAT_AUDIO_LIST" -c copy "$COMBINED_AUDIO"
echo -e "${COLOR_MATRIX}$L_JOIN_OK${COLOR_RESET}"

if [ ! -s "$COMBINED_AUDIO" ]; then
    echo "$L_ERR_AUDIO_COMB"
    read -p "$L_ENTER_EXIT"
    exit 1
fi

TOTAL_SEC=$(ffprobe -v error -show_entries format=duration -of default=noprint_wrappers=1:nokey=1 "$COMBINED_AUDIO" | cut -d. -f1)

# 8. RENDERIZADO DE VÍDEO
echo ""
echo -e "${COLOR_MATRIX}$L_STEP2${COLOR_RESET}"
echo -e "${COLOR_MATRIX}$L_PRE_COVER${COLOR_RESET}"
ffmpeg -hide_banner -loglevel error -y -i "$COVER_IMAGE" -vf "format=rgb24" "$CLEAN_COVER_TEMP"

dibujar_progreso_total 50 "$L_VIDEO_PROGRESS"

ffmpeg -hide_banner -loglevel error -y -loop 1 -r 24000/1001 -i "$CLEAN_COVER_TEMP" \
    -vf "scale=1920:1080:force_original_aspect_ratio=decrease,pad=1920:1080:(ow-ih)/2:(oh-ih)/2:black,format=yuv420p" \
    -t "$TOTAL_SEC" -c:v libx264 -profile:v high -level 4.1 -preset veryfast -crf 18 \
    -x264opts nal-hrd=vbr:force-cfr=1 -color_range tv -colorspace bt709 -color_primaries bt709 -color_trc bt709 \
    -g 24 -keyint_min 24 -bf 2 "$ALBUM_VIDEO"

limpiar_linea_progreso
echo -e "${COLOR_MATRIX}$L_VIDEO_OK${COLOR_RESET}"

if [ ! -s "$ALBUM_VIDEO" ]; then
    echo "$L_ERR_VIDEO"
    read -p "$L_ENTER_EXIT"
    exit 1
fi

# 9. AUTORÍA Y CREACIÓN DE ISO
echo ""
echo -e "${COLOR_MATRIX}$L_STEP3${COLOR_RESET}"

cat <<EOT > "$META_FILE"
MUXOPT --no-pcr-on-video-silent --blu-ray --custom-chapters=$CHAPTERS_LIST
V_MPEG4/ISO/AVC, "$ALBUM_VIDEO", fps=23.976, level=4.1
A_LPCM, "$COMBINED_AUDIO", sample_rate=$SAMPLE_RATE, bits_per_sample=24, timeshift=0
EOT

dibujar_progreso_total 85 "$L_BDMV_PROGRESS"
"$TSMUXER_CMD" "$META_FILE" "$OUTPUT_BDMV_DIR" > "$TSMUXER_LOG" 2>&1

if [ ! -d "$OUTPUT_BDMV_DIR/BDMV" ]; then
    limpiar_linea_progreso
    echo "$L_ERR_TSMUXER_EXEC"
    echo ""
    cat "$TSMUXER_LOG"
    read -p "$L_ENTER_EXIT"
    exit 1
fi

limpiar_linea_progreso
echo -e "${COLOR_MATRIX}$L_BDMV_OK${COLOR_RESET}"

dibujar_progreso_total 95 "$L_ISO_PROGRESS"
genisoimage -udf -V "$VOLUME_LABEL" -o "$ISO_NAME" "$OUTPUT_BDMV_DIR" > /dev/null 2>&1

if [ -s "$ISO_NAME" ]; then
    limpiar_linea_progreso
    BYTES_REALES=$(python3 -c "import os, sys; print(os.path.getsize(sys.argv[1]))" "$ISO_NAME")
    MB_REALES=$((BYTES_REALES / 1024 / 1024))
    
    if [ $MB_REALES -ge 1024 ]; then
        TAMANO_ISO_REAL=$(awk -v b="$BYTES_REALES" 'BEGIN {printf "%.2f GB", b/1024/1024/1024}')
    else
        TAMANO_ISO_REAL="${MB_REALES} MB"
    fi
    
    DISCO_FINAL=$(obtener_bdr_recomendado $MB_REALES)
    rm -rf "$OUTPUT_BDMV_DIR" 2>/dev/null

    dibujar_progreso_total 100 "OK"
    echo ""
    echo ""
    echo -e "${COLOR_MATRIX}=================================================="
    echo " $L_SUCCESS_TITLE"
    echo "🔊 Audio: PCM 24-bit / $LABEL_HZ"
    echo "$L_SUCCESS_ISO ./$ISO_NAME ($TAMANO_ISO_REAL)"
    echo "$L_SUCCESS_DISC $DISCO_FINAL"
    echo -e "==================================================${COLOR_RESET}"
else
    limpiar_linea_progreso
    echo "$L_ERR_ISO"
    read -p "$L_ENTER_EXIT"
    exit 1
fi

echo ""
read -p "$L_ENTER_EXIT"