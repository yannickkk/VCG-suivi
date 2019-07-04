library(RPostgreSQL)
source("C:/Users/ychaval/Documents/BD_CEFS/con_serveur_dbcefs.R")
source("C:/Users/ychaval/Documents/BD_tools/Mes_fonctions_R/fonctions.R")

dbSendQuery(con,"CREATE SCHEMA suivi")

dbSendQuery(con,"
-- Sequence: suivi.t_locobserv_loco_loco_id_seq

-- DROP SEQUENCE suivi.t_locobserv_loco_loco_id_seq;

CREATE SEQUENCE suivi.t_locobserv_loco_loco_id_seq
INCREMENT 1
MINVALUE 1
MAXVALUE 9223372036854775807
START 1
CACHE 1;
ALTER TABLE suivi.t_locobserv_loco_loco_id_seq
OWNER TO ychaval;
GRANT ALL ON SEQUENCE suivi.t_locobserv_loco_loco_id_seq TO ychaval;
GRANT ALL ON SEQUENCE suivi.t_locobserv_loco_loco_id_seq TO cefs_ecriture;")

dbSendQuery(con,"
            
            -- Table: suivi.t_locobserv_loco

            -- DROP TABLE suivi.t_locobserv_loco;
            
            CREATE TABLE suivi.t_locobserv_loco
            (
            loco_id integer NOT NULL DEFAULT nextval('suivi.t_locobserv_loco_loco_id_seq'::regclass),
            loco_ani_id integer NOT NULL, 
            loco_date date NOT NULL,
            loco_time time with time zone,
            loco_remarque text, 
            loco_geom_lb93 geometry(GEOMETRYCOLLECTION,2154), 
            loco_collier_type character varying(30), 
            loco_collier_etat character varying(30) DEFAULT 'normal',
            CONSTRAINT t_locobserv_loco_id_pk PRIMARY KEY (loco_id),
            CONSTRAINT t_locobserv_loco_ani_id_fk FOREIGN KEY (loco_ani_id)
            REFERENCES public.t_animal_ani (ani_id) MATCH SIMPLE
            ON UPDATE NO ACTION ON DELETE NO ACTION,
            CONSTRAINT t_locobserv_loco_unique UNIQUE (loco_ani_id, loco_date, loco_time)
            )
            WITH (
            OIDS=FALSE
            );
            ALTER TABLE suivi.t_locobserv_loco
            OWNER TO ychaval;
            GRANT ALL ON TABLE suivi.t_locobserv_loco TO ychaval;
            GRANT ALL ON TABLE suivi.t_locobserv_loco TO cefs_ecriture;
            GRANT SELECT ON TABLE suivi.t_locobserv_loco TO cefs_lecture;
            COMMENT ON TABLE suivi.t_locobserv_loco
            IS 'table des dernieres localisations connues des animaux';
            COMMENT ON COLUMN suivi.t_locobserv_loco.loco_id IS 'identifiant de la localisation precise ou non de l''individu';
            COMMENT ON COLUMN suivi.t_locobserv_loco.loco_ani_id IS 'identifiant de l''animal';
            COMMENT ON COLUMN suivi.t_locobserv_loco.loco_date IS 'date et de la localisation';
            COMMENT ON COLUMN suivi.t_locobserv_loco.loco_time IS 'heure de la localisation';
            COMMENT ON COLUMN suivi.t_locobserv_loco.loco_remarque IS 'remarque concernant la localisation';
            COMMENT ON COLUMN suivi.t_locobserv_loco.loco_geom_lb93 IS 'geom de la localisation';
            COMMENT ON COLUMN suivi.t_locobserv_loco.loco_collier_type IS 'VHF, GPS, GSM, collier faon';
            COMMENT ON COLUMN suivi.t_locobserv_loco.loco_collier_etat IS 'alarme GPS, mortalite, panne VHF, panne GSM';
            
            -- Index: suivi.t_locobserv_loco_geom_gist
            
            -- DROP INDEX suivi.t_locobserv_loco_geom_gist;
            
            CREATE INDEX t_locobserv_loco_geom_gist
            ON suivi.t_locobserv_loco
            USING gist
            (loco_geom_lb93);
            
            ")

