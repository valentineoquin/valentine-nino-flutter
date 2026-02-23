// On enlève le /api/ pour éviter le conflit avec le système
routerAdd("GET", "/test-import", function (e) {
    try {
        var collection;
        try {
            collection = $app.findCollectionByNameOrId("recalls");
        } catch (err) {
            // La collection n'existe pas, on va la créer
        }

        if (!collection) {
            console.log("Création de la collection 'recalls'...");
            collection = new Collection({
                name: "recalls",
                type: "base",
                schema: [ // Attention: Dans certaines versions c'est 'schema', dans d'autres 'fields'
                    { name: "externalId", type: "text", required: true },
                    { name: "gtin", type: "text" },
                    { name: "libelle", type: "text" },
                    { name: "marque", type: "text" },
                    { name: "motif", type: "text" }
                ]
            });
            $app.save(collection);
        }

        console.log("Appel de l'API...");
        var url = "https://data.economie.gouv.fr/api/explore/v2.1/catalog/datasets/rappelconso-v2-gtin-trie/records?limit=100";
        var res = $http.send({ url: url, method: "GET" });
        
        var data = res.json;
        if (!data.results) throw new Error("Format API invalide");

        data.results.forEach(function (item) {
            var extId = String(item.id || i);
            var record;
            try {
                record = $app.findFirstRecordByData("recalls", "externalId", extId);
            } catch (err) {
                record = new Record(collection);
            }

            // Identifiants
                record.set("externalId", extId);
                record.set("gtin", String(item.gtin || ""));

                // Informations produit
                record.set("libelle", String(item.nom_commercial_du_produit || item.libelle || ""));
                record.set("marque", String(item.marque_produit || ""));
                record.set("categorie", String(item.categorie_produit || ""));
                record.set("sous_categorie", String(item.sous_categorie_produit || ""));

                // Détails du rappel
                record.set("motif", String(item.motif_rappel || ""));
                record.set("risques", String(item.risques_encourus || ""));
                record.set("date_publication", String(item.date_publication || ""));

                // Liens médias
                // L'API renvoie souvent plusieurs images séparées par un |, on prend la première
                var images = item.liens_vers_les_images ? String(item.liens_vers_les_images).split('|') : [];
                record.set("image_url", images.length > 0 ? images[0] : "");
                
                record.set("fiche_url", String(item.lien_vers_la_fiche_rappel || ""));

            $app.save(record);
        });

        return e.json(200, { success: true, message: "Importation réussie" });
    } catch (err) {
        console.log("ERREUR : " + err.toString());
        return e.json(500, { error: err.toString() });
    }
});