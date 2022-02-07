SELECT bebaut, wkb_geometry AS geometrie FROM digizone.bebauung WHERE archive = 0 AND wkb_geometry IS NOT NULL;
