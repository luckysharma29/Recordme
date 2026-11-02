# ADR 0004: iOS call capture strategy

Status: Accepted (ReplayKit mode pending spike)

## Context
iOS sandboxing prevents third-party apps from recording another app's VoIP call audio or cellular calls. Plaud works around this with a hardware vibration sensor, which is out of scope (NG3).

## Decision
Offer four legitimate paths, clearly explained in the UI:
1. In-person / speakerphone recording via microphone.
2. Import of iOS 18.1+ native Phone call recordings and any audio file.
3. Mac handoff: join the call on the Mac, Mac records, transcript syncs to iPhone.
4. Experimental ReplayKit broadcast extension, shipped only if the spike shows usable audio for at least one major meeting app.

## Consequences
* We avoid fragile or App Review rejected techniques.
* Users must understand that "record Teams on iPhone" is best done via speaker or Mac.
