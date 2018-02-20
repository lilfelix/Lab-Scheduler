# Lab scheduler 

En  villkorsprogrammerings-modell  för  att  schemalägga  redovisningar  av labbar

Programmet automatiserar schemaläggning av redovisning av labbar i en kurs. Kursen har ett antal olika labbar, och studenter har skickat in lösningar på dessa. 
De data som är givna är en mängd labb-lösningar, samt hur  många  labbhandledare  som  är  tillgängliga,  och  hur  många  redovisningstider  som  finns  för  varjelabbhandledare.

###### Varje labb-lösning specificeras av två parametrar:

1. Vilken labb som lösts
2. Vilken delmängd studenter som gjort lösningen (typiskt två studenter då de jobbar i par).

Antal handledare och redovisningstider ges helt enkelt av varsitt heltal.
Givet dessa data vill vi schemalägga en mängd redovisningar.

###### Varje redovisning specificeras av fyra parametrar:

1.  Vilken labb som redovisas
2.  Vilka studenter som ingår i denna redovisningsgrupp
3.  Vilken handledare som de ska redovisa för
4.  Vilken tid de ska redovisa

###### Följande villkor gäller för redovisningspassen:

* Varje student ska få redovisa exakt de labbar hen löst, och inte behöva redovisa någon labb merän en gång.
* Redovisningsgrupperna ska bestå av grupper om 2 studenter (i undantagsfall en grupp per labbmed 3 studenter, om det är ett udda antal studenter som gjort den labben).
* Varje student ska redovisa varje labb tillsammans med en annan student (eller två andra, i un-dantagsfallet med en redovisningsgrupp av storlek 3) än den/de studenter som hen gjort labbentillsammans med. Med andra ord: om två studenter jobbat tillsammans på en lab ska de inte hamna i samma redovisningsgrupp för den labben (men om de båda ska redovisa någon annan labboch inte jobbat tillsammans på den så är det OK om de hamnar i samma redovisningsgrupp förden andra labben).
* En labbhandledare kan inte vara inbokad på två olika redovisningar vid samma tidpunkt.
* En student kan inte vara inbokad på två olika redovisningar vid samma tidpunkt.
