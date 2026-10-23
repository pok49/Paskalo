# Paskalo, esperantigita *Pascal*

> “Paskalo” is pseudocode based on the Pascal programming language by
> Niklaus Wirth, adapted for use in Esperantic studies of Computer Science.

**Paskalo** estas esperantigita programlingvo *Pascal* uzata en kelkaj
esperantlingvaj verkoj (ekz‑e [Komputada Leksikono](https://eo.wikipedia.org/wiki/Komputada_Leksikono), esperanta
[Vikipedio](https://eo.wikipedia.org/wiki/Paskalo_(programlingvo))) kiel pseŭdokodo por prezenti al lernantoj kaj legantoj
bazajn nociojn de programado kaj krestomatiajn algoritmojn.

Por faciligi legadon de la pseŭdokodaj programoj dezirindas forigi la
lingvan baron — en la okazo de esperanta verko, ebligi la uzon de la
esperanta leksiko. Konkrete tio postulas
 * disponeblon de la literoj de Esperanto, kaj
 * esperantigon de la ŝlosilvortoj kaj antaŭdifinitaj nomoj de la
   funkcioj, konstantoj ktp.

Ambaŭ postuloj prezentas nenian problemon en la publikaĵoj
(tipografiaj, retaj aŭ bitlibraj) — Unikodaj tiparoj nun ĉie
disponeblas, kaj la tradukoj de la Paskalaj ŝlosilvortoj ekzistas jam
de post 1995 (kiam ilin publikigis la «Komputika leksikono»,
pp. 245‒246, rete [ĉi tie](https://bertilow.com/div/komputada_leksikono/PRI-PAS.html#Sxlosilvortoj-de-Pascal-kaj-Paskalo) kaj [en Vikipedio](https://eo.wikipedia.org/wiki/Paskalo_(programlingvo))). Sed utilus havi komputilan
realigon de Paskalo, por fidinde kontroli la prezentajn algoritmojn.

Estus troa heroaĵo realigi esperantigitan Paskalan tradukilon (compiler), sed
estas relative facila afero fari Paskalan antaŭtraktilon
(preprocessor) por jam ekzistanta tradukilo angleca. Kaj tion mi
faris, kiel estas priskribite ĉi-sube.

## La baza tradukilo
Estkiel bazon mi prenis la «liberan Paskal-tradukilon» `fpc` (vd ĉe
«[free Pascal](https://www.freepascal.org/)»). Ĝi estas disponebla por multaj komputilaj arkitekturoj
kaj operaciumoj (Windows, Linux, Mac OS X/iOS/iPhoneSimulator/Darwin,
FreeBSD, DOS…); mi instalis la linuksan `fp-compiler-3.2.2` de la
Ubunta deponejo.

`fpc` scipovas Unikodon interne, en signoĉenoj kaj rultempe (almenaŭ en
Linukso, kaj supozeble en aliaj sistemoj kies operaciumo estas
Unikodo-kapabla), ekz‑e:

```console
% cat -n ehxo.pas
     1  PROGRAM ehxo;
     2  BEGIN
     3     writeLn('Eĥoŝanĝo ĉiuĵaŭde');
     4  END.
% ifpc ehxo.pas
Eĥoŝanĝo ĉiuĵaŭde
%
```

(`ifpc` estas «interpreta `fpc`», angle *interpreter fpc;* ĝi tradukas la
argumentan programon kaj tuj rulas la tradukitan programon.)

Tamen en la *nomoj* de programaj leksemoj (angle *identifiers*) `fpc`
toleras nur la Askiajn literojn (kaj ankaŭ la ciferojn kaj la substrekon,
kompreneble). Do, la ĉapelitaj literoj estas malpermesitaj en la
nomoj; uzante `fpc` necesas iksigi la esperantajn vortojn (kiel la
nomon `ehxo` en la linio 1 de la ĵusa ekzemplo). Tio estas malbona.

Tamen bonaĵo estas, ke `fpc` disponigas antaŭtraktilajn makroojn. Tial
eblas uzi tradukojn:
~~~console
% cat -n makroehxo.pas
     1  {$MACRO ON}
     2  {$define FINO:=END}
     3  {$define PROGRAMO:=PROGRAM}
     4  {$define skribuLin:=Writeln}
     5  {$define STARTO:=BEGIN}
     6
     7  PROGRAMO makroehxo;
     8  STARTO
     9     skribuLin('Eĥoŝanĝo ĉiuĵaŭde');
    10  FINO.
% ifpc makroehxo.pas
Eĥoŝanĝo ĉiuĵaŭde
% 
~~~
Tio ebligas prezenti plenvalorajn programojn (kiuj traktas
verajn esperantajn tekstojn en Unikodo kun la ĉapelitaj leteroj);
ankaŭ eblas uzi en la programoj la tradukitajn simbolvortojn, tamen
surogate skribitajn. La makroojn eblas kolekti en apartan dosieron
`makrooj.inc`, kaj anstataŭ la linioj 1–5 meti la direktivon
   {$INCLUDE 'makrooj.inc'}
Bedaŭrinde ankaŭ la antaŭtraktilo de `fpc` ne toleras eksteraskiajn
literojn en la makroaj nomoj.

## La Perla skripto
Tamen la modernaj lingvoj (ekz‑e *Python*) ja permesas uzi Unikodajn
literojn (kaj sekve ankaŭ la literojn esperantajn) en la simbolvortoj
kaj nomoj. Tial mi verkis en Perlo antaŭ-antaŭtraktilan skripton `psk`, kiu
 1. Iksigas la programajn nomojn kaj simbolvortojn *ekster la komentoj
    kaj signoĉenoj*. La komentojn kaj la signoĉenojn `psk` lasas
    senŝanĝaj; tio ebligas i.a. printi la vortojn kiaj `Eĥoŝanĝo ĉiuĵaŭde`.
 2. Tradukas kelkajn pseŭdokodajn simbolojn (ekz‑e ≤ ≠ ≥ ↑) en iliajn
    Askiajn prezentojn (respektive `<=` `<>` `>=` `^`).
 3. Antaŭ la unua linio de la programo ĝi enŝovas la direktivon
    `{$INCLUDE 'makrooj.inc'}`.
 4. Se vokite kun la opcio `-A`, la skripto plenumas nur la askiigon,
    kaj sendas la rezulton en la dukton (angle *pipe*), aŭ registras
    ĝin en la dosiero indikita per la kroma opcio `-o `‹dosiernomo›.
 4. Aliokaze `psk` sendas la rezulton per la dukto al `ifpc`, kiu ĝin
    tradukas kaj plenumas la programon.

## Ekzemploj
Ni konsideru la pseŭdokodan (Paskalan) programon `ehxo.psk` (mi uzas
la sufikson `.psk` por la programoj PSeŭdoKodaj kaj PaSKalaj,
kontraste al la sufikso `.pas` kiun atendas la tradukilo `fpc`):
```console
% cat -n ehxo.psk
     1  PROGRAMO eĥoŝanĝo;
     2    TIPOJ semajntago = (lu, ma, me, ĵa, ve, sa, di);
     3          rref = ↑reela; { la sago in ↑T estas askiigata per ĉapelo: ^T }
     4    VAR   hodiaŭ : semajntago; aux: Bulea;
     5  STARTO
     6       aux := (1 ≠ 2) AŬ vero;    { tio iĝos: &aux := (1 <> 2) AUX vero }
     7       hodiaŭ := ĵa;
     8       skribuLin('Eĥoŝanĝo ĉiuĵaŭde, hodiaŭ estas ', hodiaŭ);
     9  FINO.
% psk ehxo.psk 
Eĥoŝanĝo ĉiuĵaŭde, hodiaŭ estas jxa
%
% psk -A ehxo.psk | cat -n
     1  {$INCLUDE 'makrooj.inc'} PROGRAMO ehxosxangxo;
     2    TIPOJ semajntago = (lu, ma, me, jxa, ve, sa, di);
     3          rref = ^reela; { la sago in ↑T estas askiigata per ĉapelo: ^T }
     4    VAR   hodiaux : semajntago; &aux: Bulea;
     5  STARTO
     6       &aux := (1 <> 2) AUX vero;    { tio iĝos: &aux := (1 <> 2) AUX vero }
     7       hodiaux := jxa;
     8       skribuLin('Eĥoŝanĝo ĉiuĵaŭde, hodiaŭ estas ', hodiaux);
     9  FINO.
%
```


## Avizoj
 1. Lininumeroj. Ekz‑e se `fpc` plendas pri eraro en la linio 6, tio
    temas la *traktita* linio 6, kiu respondas al la fonta linio 5. 
 2. Rezervitaj vortoj
 3. `fpc` havas malgrandan adapteblon por internaciigo. I.a. la
    rultempa programaro (RTL) malhavas internaciigajn rimedojn; tial ekz‑e
    `skribuLin(vero)` printos la anglalingvan `TRUE`. Tamen, la
    fpc-aj erarmesaĝoj probable estas tradukeblaj (sed mi ne faris tion).


## Instalo
Necesas FPC.
Necesas Perlo de la versio ne pli frua ol 5.10 (mi uzis v5.34).  

Certigu ke `psk` estas plenumebla:
```sh
chmod a+x psk
```

Se vi volas simple provi kaj iom ludi kun la antaŭtraktilo, vi povas
teni ĉion (la dosierojn `makrooj.inc`, la Perlan skripton `psk` kaj viajn
testajn pseŭdokodajn programojn) kune unu en sola eksperimenta dosierujo.

Se vi volas havi pli korektan aranĝon (kaj voki `psk` el ajna via
dosierujo), vi povas meti `psk` en iu ajn dosierujo listigita en via
`$PATH` — vidu
```sh
echo $PATH
```

Ĉe la tradicia Linuksa aranĝo vi havos tie, inter aliaj, `~/.local/bin`,
kiu estas konvena loko. En la saman `~/.local/`-hierarkion konvenas meti
la makroojn:
```sh
mkdir ~/.local/share/psk/
mv makrooj.inc ~/.local/share/psk/
```

Ĝuste tiun lokon la skripto `psk` aldonas al la inkluda serĉvojo ĉe la
voko de `ifpc` (`$inc_dir="$ENV{HOME}/.local/share/psk/"`)

## Majuskloj

***Is there a tradition to use all-caps for the reserved Pascal word-symbols?**

There are **two competing traditions**:

| **Convention** | **Where it's used** | **Rationale** |
| - | - | - |
| **UPPERCASE** | Borland/Turbo Pascal era, many university style guides, older textbooks | Visually distinguishes keywords from identifiers at a glance |
| **lowercase** | Wirth's original, FPC reference guide, GNU Pascal coding standards, modern Lazarus examples | Matches the language definition; avoids shouting |

The **FPC reference guide** itself uses lowercase in all its syntax diagrams and examples (`begin`, `end`, `if`). The **GNU Pascal coding standards** explicitly prescribe "flat" (lowercase) for reserved words. 

The uppercase tradition is mostly a **Borland-era holdover** — the Turbo Pascal IDE and its documentation displayed keywords in caps, and that style bled into countless codebases and course materials. Keith Brown's 1998 Pascal Style Guide is a typical example: *"Use all upper case for reserved words."*

Since FPC is case-insensitive, both compile identically. Pick whichever your team or course uses and stay consistent. If you're writing for the FPC/Lazarus community, **lowercase** is the de facto norm.

## Latin-3 en FPC

The full ISO 8859 series (parts 1–11, 13–16) is available. You can just use it directly:

```delpi
program Demo;
uses cp8859_3;  { registers Latin-3 }
begin
  { ... }
end.
```
Or via the {$codepage} directive:
  {$codepage cp8859_3}
Tamen tio ne ebligas uzoj de la ĉapelitaj literoj en la programaj
nomoj. Ankaŭ la uzado de Latino-3a en terminalo aŭ redaktilo estas
maloportuna (ĉar nekutima).

## Referencoj
 * [free pascal site](https://www.freepascal.org/)



