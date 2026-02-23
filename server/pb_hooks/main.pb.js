// main.pb.js

// --- FONCTION CENTRALE D'IMPORTATION ---
function performImport() {
    try {
        var collection;
        try {
            collection = $app.findCollectionByNameOrId("recalls");
        } catch (err) {
            // La collection n'existe pas encore
        }

        // Création de la collection si elle est absente
        if (!collection) {
            console.log("Création de la collection 'recalls'...");
            collection = new Collection({
                name: "recalls",
                type: "base",
                schema: [
                    { name: "externalId", type: "text", required: true },
                    { name: "gtin", type: "text" },
                    { name: "libelle", type: "text" },
                    { name: "marque", type: "text" },
                    { name: "categorie", type: "text" },
                    { name: "sous_categorie", type: "text" },
                    { name: "motif", type: "text" },
                    { name: "risques", type: "text" },
                    { name: "date_publication", type: "text" },
                    { name: "image_url", type: "text" },
                    { name: "fiche_url", type: "text" }
                ]
            });
            $app.save(collection);
        }

        console.log("Appel de l'API RappelConso...");
        // API v2.1 (version 2026 compatible)
        var url = "https://data.economie.gouv.fr/api/explore/v2.1/catalog/datasets/rappelconso-v2-gtin-trie/records?limit=100";
        var res = $http.send({ url: url, method: "GET" });
        
        var data = res.json;
        if (!data.results) throw new Error("Format API invalide ou pas de résultats");

        data.results.forEach(function (item) {
            var extId = String(item.id || "");
            if (!extId) return; // On saute si pas d'ID

            var record;
            try {
                // On cherche si le produit existe déjà via son ID externe
                record = $app.findFirstRecordByData("recalls", "externalId", extId);
            } catch (err) {
                // Sinon on crée un nouvel enregistrement
                record = new Record(collection);
            }

            // Mise à jour des champs
            record.set("externalId", extId);
            record.set("gtin", String(item.gtin || ""));
            record.set("libelle", String(item.nom_commercial_du_produit || item.libelle || ""));
            record.set("marque", String(item.marque_produit || ""));
            record.set("categorie", String(item.categorie_produit || ""));
            record.set("sous_categorie", String(item.sous_categorie_produit || ""));
            record.set("motif", String(item.motif_rappel || ""));
            record.set("risques", String(item.risques_encourus || ""));
            record.set("date_publication", String(item.date_publication || ""));

            // Gestion de l'image (on prend la première si plusieurs sont présentes)
            var images = item.liens_vers_les_images ? String(item.liens_vers_les_images).split('|') : [];
            record.set("image_url", images.length > 0 ? images[0] : "");
            
            record.set("fiche_url", String(item.lien_vers_la_fiche_rappel || ""));

            $app.save(record);
        });

        console.log("Importation réussie : " + data.results.length + " produits traités.");
    } catch (err) {
        console.log("ERREUR IMPORT : " + err.toString());
        throw err; // On propage l'erreur pour le log du router
    }
}

// --- 1. ROUTE POUR TEST MANUEL ---
// URL : http://127.0.0.1:8090/test-import
routerAdd("GET", "/test-import", function (e) {
    try {
        performImport();
        return e.json(200, { success: true, message: "Importation manuelle réussie" });
    } catch (err) {
        return e.json(500, { success: false, error: err.toString() });
    }
});

// --- 2. PLANIFICATION AUTOMATIQUE (CRON) ---
// S'exécute 2 fois par jour (à minuit et à midi)
// Syntaxe : minute heure jour mois jour_de_semaine
cronAdd("importRecalls", "0 0,12 * * *", function () {
    console.log("Déclenchement du cron : Importation automatique en cours...");
    performImport();
});