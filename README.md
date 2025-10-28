# dynamic-camber-control

### Sturzdefinition

Kücükay S.960

<br>

### Systemanforderungen

| ID      | Kategorie        | Priorität | Stakeholder | Status        | Link                                     |
|---------|------------------|-----------|-------------|---------------|------------------------------------------|
| SYS-001 | Funktional       | Muss      | Kunde       | nicht erfüllt | [mehr](docs/01_requirements/SYS-001.md)  |
| SYS-002 | Nicht-funktional | Soll      | Kunde       | nicht erfüllt |
| SYS-003 | Nicht-funktional | Soll      | Kunde       | nicht erfüllt |
| SYS-004 | Nicht-funktional | Soll      | Kunde       | nicht erfüllt |
| SYS-004 | Nicht-funktional | Kann      | Kunde       | nicht erfüllt |

<br>

### Herangehensweise
 Vertikalmodell liefert unter anderem Hubweg z oder Federwege zi woraus sich die Raderhebungskurve und damit ein Sturzwinkel ergibt. Dieser Sturzwinkel muss dann noch in einem Kennfeld korrigiert werden sodass sich der Sturzwinkel mit dem höchsten Kraftschlusspotential bei aktueller Fahrsituation ergibt
<br><br>

 <div style="text-align: center;">
   <img src="docs/99_appendices/dcc_regelkreis.svg" alt="System als Block" width="auto" height="100%">
 </div><br>

Vorteil von inklusion des Vertikalmodells ist das der aktuell eingestellte Sturzwinkel keine Rolle spielt, es wird lediglich das optimum bei in abhöngigkeit der Fahrsituation evaluiert.
<br>

Fragen:
- Gibt es einen Denkfehler im Regelkreis bzw. gibt es eine Situation in der das Vertikalmodell nicht notwendig ist?
- Verwendung des Vertikalmodells Zielführend?
- Wie verändert sich das Kennfeld mit der Raderhebung? 

<br>

### Vertikalmodell

aus Kücükay <br><br>


<div style="display: flex;">

<div style="flex: 1;">

$z_1 =~ z - \sin(\kappa) \cdot (s_V/2) + \sin(\phi) \cdot l_{NZ,V}$<br>
$z_2 =~ z + \sin(\kappa) \cdot (s_V/2) + \sin(\phi) \cdot l_{NZ,V}$<br>
$z_3 =~ z - \sin(\kappa) \cdot (s_V/2) + \sin(\phi) \cdot (l - l_{NZ,V})$<br> 
$z_4 =~ z + \sin(\kappa) \cdot (s_V/2) + \sin(\phi) \cdot (l - l_{NZ,V})$<br><br>
$F_{Fi} =~ c_{Ai} \cdot z_i$<br>
$F_{Di} =~ d_{Ai} \cdot \dot{z_i}$<br><br>
$F_{D,V} =~ F_{D1} + F_{D2}$<br>
$F_{D,H} =~ F_{D3} + F_{D4}$

</div>

<div style="flex: 1; text-align: center;">

<img src="docs/99_appendices/vertikal_nicken.png" alt="System als Block" width="auto">

</div>

</div>


<br>

### Bestimmung der Parameter
