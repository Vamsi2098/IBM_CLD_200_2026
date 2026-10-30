namespace galaxy.reuse;

// reusable type
type Guid : String(32);

// aspect: a bundle of fields any entity can include
aspect baseLocation {
    sector: String(10);
    planet: String(32);
    moon: String(32);
    orbitAltitude: Int16;
    galaxyCode: String(2);
}