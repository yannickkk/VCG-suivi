###########################production de listes des choix utilisables dans l'outil de saisie, saisir l'année et un vecteur contenant les ani_etiq des animaux à localiser

library(RPostgreSQL)
source("C:/Users/ychaval/Documents/BD_CEFS/data/VCG/data_suivi/Programmes/R_no_git/con_serveur_dbcefs.R")

ani_etiq<-c("858") ###pour rajouter des animaux ani_etiq<-c("858","937") 

annee<-c("2019","2018")

annee<-paste0("('",paste0(annee, collapse="','"),"')")
suple<-paste0("('",paste0(ani_etiq, collapse="','"),"')")

dbSendQuery(con,
           paste0("
-- View: suivi.v_liste_animaux

-- DROP VIEW suivi.v_liste_animaux;

CREATE OR REPLACE VIEW suivi.v_liste_animaux AS 
SELECT t_animal_ani.ani_id,
concat(t_animal_ani.ani_name, '_', t_animal_ani.ani_etiq) AS nom,
NULL::geometry AS geom
FROM t_capture_cap,
t_animal_ani
WHERE t_capture_cap.cap_ani_id = t_animal_ani.ani_id AND date_part('year'::text, t_capture_cap.cap_date) in ",annee," AND t_animal_ani.ani_mortalite = false
UNION
SELECT t_animal_ani.ani_id,
t_animal_ani.ani_etiq AS nom,
NULL::geometry AS geom
FROM t_animal_ani
WHERE t_animal_ani.ani_etiq in ",suple," ;

ALTER TABLE suivi.v_liste_animaux
OWNER TO db_cefs_terrain;
GRANT ALL ON TABLE suivi.v_liste_animaux TO morellet;
GRANT ALL ON TABLE suivi.v_liste_animaux TO db_cefs_terrain;
GRANT ALL ON TABLE suivi.v_liste_animaux TO ychaval;
GRANT SELECT ON TABLE suivi.v_liste_animaux TO cefs_lecture;
GRANT SELECT ON TABLE suivi.v_liste_animaux TO cefs_ecriture;"))


dat<-dbGetQuery(con,
                paste0("SELECT ani_id, concat(ani_name,'_',ani_etiq) as nom
FROM public.t_animal_ani WHERE ani_name IN (select ani_name from t_animal_ani, t_capture_cap where ani_id = cap_ani_id and extract(year from cap_date) IN ",annee," AND ani_mortalite = FALSE)
UNION
SELECT ani_id, ani_etiq as nom
FROM public.t_animal_ani where ani_etiq in ",suple,""))
setwd("C/Users/ychaval/Documents/BD_CEFS/data/VCG/data_suivi/Programmes/Qgis")
write.csv(dat,"liste_animaux_suivi.csv", row.names = FALSE)