# diagnostic-device-bluetooth


    Projet d’apprentissage système embarqué
    Analyse complète de la compatibilité Linux d’un adaptateur TP-Link Bluetooth 5.4 USB (ID 2357:0604).
    De lsusb à dmesg, en passant par le firmware Realtek et la pile BlueZ — une plongée technique dans le fonctionnement des périphériques USB sous Linux.

    Ce projet documente l'expérimentation et le diagnostic d’un adaptateur TP-Link Bluetooth 5.4 USB sur un système Linux (Debian 12).
    But : montrer comment analyser la compatibilité matérielle, diagnostiquer les problèmes, et valider le fonctionnement.

🖥️ Fonctionnalités

    Détection automatique du périphérique (via lsusb)
    Identification du chipset Realtek RTL8761BU
    Vérification du chargement du firmware
    Contrôle de l’installation de BlueZ
    Sortie colorée et claire

🎯 Objectif

Ce projet documente une démarche d’investigation système pour :

    Comprendre pourquoi un adaptateur Bluetooth fonctionne sous Windows mais pas immédiatement sous Linux.
    Identifier les composants matériels et logiciels impliqués.
    Valider la compatibilité, diagnostiquer les problèmes, et rétablir le fonctionnement.

Il sert de preuve technique de :

    Maîtrise des outils système Linux (lsusb, dmesg, dpkg)
    Compréhension du noyau, du firmware et des pilotes
    Recherche autonome et résolution de problèmes

🖥️ Périphérique analysé

    Modèle : TP-Link Bluetooth 5.4 USB Adapter
    ID USB : 2357:0604
    Chipset : Realtek RTL8761BU
    Firmware chargé : rtl8761bu_fw.bin et rtl8761bu_config.bin
    Système hôte : Debian 12 (noyau 6.1.0-37-amd64)
