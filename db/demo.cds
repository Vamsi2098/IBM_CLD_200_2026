namespace com.sap;

using {galaxy.reuse as nasa} from './reuse';
using {
    cuid,
    managed
} from '@sap/cds/common';

context galaxy {
    entity astronaut : cuid, managed, nasa.baseLocation {
        // remove: key id
        callSign      : String(80);
        homePlanet    : String(80);
        missionsFlown : Int16;
        rank          : String(1);
        ship          : Association to spaceship;
    }

    entity spaceship : cuid, managed, nasa.baseLocation {
        // remove: key id
        shipName     : localized String(80);
        crewCapacity : Int16;
        engineType   : String(60);
        crew         : Association to many astronaut
                           on crew.ship = $self;
    }
}
