// pb_hooks/main.pb.js

onAfterBootstrap((e) => {
    console.log("Initialisation de la base de données...");

    let collection;
    try {
        collection = $app.findCollectionByNameOrId("recalls");
        console.log("Collection 'recalls' existe déjà.");
    } catch (err) {
        console.log("Création de la collection 'recalls'...");
        collection = new Collection({
            name: "recalls",
            type: "base",
            schema: [
                { name: "gtin", type: "text", required: true },
                { name: "libelle", type: "text" },
                { name: "marque_produit", type: "text" },
                { name: "lien_image", type: "text" },
                { name: "date_debut_commercialisation", type: "text" },
                { name: "date_fin_commercialisation", type: "text" },
                { name: "distributeurs", type: "text" },
                { name: "zone_geographique_de_vente", type: "text" },
                { name: "motif_rappel", type: "text" },
                { name: "risques_encourus", type: "text" },
                { name: "informations_complementaires", type: "text" },
                { name: "conduites_a_tenir", type: "text" },
                { name: "lien_fiche_pdf", type: "text" }
            ],
            listRule: "",
            viewRule: "",
            createRule: "",
            updateRule: "",
            deleteRule: ""
        });
        
        $app.save(collection);
        console.log("Collection 'recalls' créée avec succès.");
    }

    // Vérifier si le produit factice est déjà dans la base
    try {
        $app.findFirstRecordByData("recalls", "gtin", "5000159484695");
        console.log("Les données de test existent déjà.");
    } catch (err) {
        console.log("Insertion des données de test...");
        const record = new Record(collection);
        record.set("gtin", "5000159484695");
        record.set("libelle", "Petits pois et carottes");
        record.set("marque_produit", "Cassegrain");
        record.set("lien_image", "https://i.goopics.net/f20108.jpg"); 
        record.set("date_debut_commercialisation", "27/10/2025");
        record.set("date_fin_commercialisation", "29/01/2026");
        record.set("distributeurs", "ALDI - AUCHAN - CARREFOUR - CASINO - CORA - INTERMARCHE - LECLERC - LIDL - MONOPRIX - SCHIEVER - SYSTÈME U");
        record.set("zone_geographique_de_vente", "France entière");
        record.set("motif_rappel", "Ce rappel est mis en œuvre par mesure de précaution afin de protéger les personnes allergiques au lait, absent sur la liste d'ingrédients. Il existe de ce fait un risque pour les personnes allergiques au LAIT.");
        record.set("risques_encourus", "Substances allergisantes non déclarées");
        record.set("informations_complementaires", "Aucune information supplémentaire.");
        record.set("conduites_a_tenir", "Ne plus consommer | Rapporter le produit au point de vente | Détruire le produit");
        record.set("lien_fiche_pdf", "https://rappel.conso.gouv.fr/");

        $app.save(record);
        console.log("Données de test insérées avec succès.");
    }
});