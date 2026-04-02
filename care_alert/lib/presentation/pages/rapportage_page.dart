import 'package:care_alert/presentation/components/layout.dart';
import 'package:flutter/material.dart';

class SoapRapportage {
	final String id;
	final String category;
	final String severity;
	final String status;
	final String location;
	final String reporter;
	final int timestamp;
	final String subjectief;
	final String objectief;
	final String analyse;
	final String plan;
	final List<RapportageEntry> rapportages;

	SoapRapportage({
		required this.id,
		required this.category,
		required this.severity,
		required this.status,
		required this.location,
		required this.reporter,
		required this.timestamp,
		required this.subjectief,
		required this.objectief,
		required this.analyse,
		required this.plan,
		required this.rapportages,
	});
}

class RapportageEntry {
	final String id;
	final String auteur;
	final String type;
	final int timestamp;
	final String beschrijving;

	RapportageEntry({
		required this.id,
		required this.auteur,
		required this.type,
		required this.timestamp,
		required this.beschrijving,
	});
}

class RapportagePage extends StatefulWidget {
	const RapportagePage({super.key});

	@override
	State<RapportagePage> createState() => _RapportagePageState();
}

class _RapportagePageState extends State<RapportagePage> {
	final TextEditingController _searchController = TextEditingController();
	final TextEditingController _newEntryController = TextEditingController();
	final TextEditingController _editEntryController = TextEditingController();

	List<SoapRapportage> _rapportages = [];
	SoapRapportage? _selectedRapportage;
	String _filterCategory = 'all';
	String _filterSeverity = 'all';
	bool _showAddRapportage = false;
	String? _editingEntryId;

	@override
	void initState() {
		super.initState();
		_rapportages = _seedRapportages();
	}

	@override
	void dispose() {
		_searchController.dispose();
		_newEntryController.dispose();
		_editEntryController.dispose();
		super.dispose();
	}

	List<SoapRapportage> _seedRapportages() {
		final now = DateTime.now().millisecondsSinceEpoch;
		return [
			SoapRapportage(
				id: 'SOAP-2026-001',
				category: 'zorg',
				severity: 'Hoog',
				status: 'definitief',
				location: 'Kamer 24B, Afdeling Woonzorg',
				reporter: 'Sophie van Dijk (Verzorgende IG)',
				timestamp: now - 7200000,
				subjectief: '''WAT DE CLIENT/BETROKKENE ZEGT:
Mevrouw De Jong (87 jaar) geeft aan: "Ik wilde naar de wc gaan, maar ik voelde me duizelig en ben gestruikeld over het matje. Mijn heup doet zeer aan de rechterkant."

CONTEXT VAN MELDER (Sophie van Dijk - Verzorgende IG):
"Ik hoorde een doffe klap vanuit de kamer van mevrouw De Jong. Toen ik binnenkwam lag ze op de grond naast haar bed. Ze was bij bewustzijn en kon mij direct aanspreken. Ze gaf aan duizelig te zijn geweest en gestruikeld te zijn. Ik heb haar niet verplaatst en direct de dienstdoende verpleegkundige gebeld."''',
				objectief: '''PROFESSIONELE OBSERVATIES:
- Datum/tijd: 1-4-2026, 08:59:22
- Locatie: Kamer 24B, Afdeling Woonzorg
- Zorgverlener: Sophie van Dijk (Verzorgende IG)
- Documentatie: Foto's aanwezig

FYSIEKE OBSERVATIES:
- Positie: Op grond naast bed, rechter zijligging
- Bewustzijn: Alert, georienteerd op tijd/plaats/persoon
- Verwondingen: Lichte roodheid rechter heup, geen open wonden
- Mobiliteit: Beperkt rechter been, pijn bij beweging
- Pijnscore: VAS 7/10 bij beweging, VAS 4/10 in rust

VITALE FUNCTIES (14:25 uur):
- Bloeddruk: 155/90 mmHg (verhoogd)
- Hartslag: 92 bpm (regulair)
- Temperatuur: 36.7 C
- Saturatie: 96%
- Ademhaling: 18/min
- Glucose: 6.2 mmol/L''',
				analyse: '''PROFESSIONELE BEOORDELING:
Ernst incident: Hoog
Directe medische actie is vereist. Verdenking op heupfractuur op basis van pijnklachten, beperkte mobiliteit en mechanisme (val uit stand bij oudere persoon).

RISICO-INSCHATTING:
ACUTE RISICO'S:
- Hoog risico op fractuur collum femoris gezien leeftijd, valmoment en pijnklachten
- Verhoogde bloeddruk door stress/pijn, monitoring vereist
- Risico op shock bij verplaatsing zonder stabilisatie
- Secundaire verwondingen bij onjuiste mobilisatie

ONDERLIGGENDE FACTOREN:
- Duizeligheid als pre-incident symptoom: cardiale oorzaak of orthostatische hypotensie?
- Valgevaar in kamer: losliggend matje geidentificeerd
- Medicatiecheck nodig: gebruikt mevrouw bloedverdunners/bloeddrukverlagende middelen?

MELDINGSPLICHT:
Dit incident is meldingsplichtig bij IGJ conform Wet kwaliteit, klachten en geschillen zorg (Wkkgz).
Categorie: Onbedoelde of onverwachte gebeurtenis met ernstig schadelijk gevolg (artikel 11 lid 1).

VERVOLGTRAJECT:
- Acute medische beoordeling door huisarts/SEH vereist
- Rontgenonderzoek heup/bekken geindiceerd
- Incident doorgestuurd naar Zorgcoordinatie, dienstdoende verpleegkundige en BIG-geregistreerd verpleegkundige voor verdere beoordeling.''',
				plan: '''ACUTE ACTIESTAPPEN:
1. Incident direct geregistreerd in zorgdossier (14:20 uur)
2. Client niet verplaatst - in stabiele zijligging gelaten
3. Dienstdoende verpleegkundige direct ter plaatse (Linda Bakker, 14:22 uur)
4. Huisarts gebeld voor spoedconsult (14:25 uur) - niet beschikbaar
5. 112 gebeld voor ambulancevervoer naar SEH (14:28 uur)
6. Pijnbestrijding: Paracetamol 1000mg oraal toegediend (14:30 uur)
7. Contactpersoon (dochter) geinformeerd (14:35 uur)

VERVOLGACTIES:
8. Transport naar SEH Medisch Centrum Zuid (ambulance vertrek 14:45 uur)
9. Overdracht aan SEH: volledige incidentrapportage en medicatielijst meegegeven
10. Interne analyse: valrisico-analyse en omgevingsinspectie gepland
11. Evaluatiegesprek met betrokken medewerkers (gepland: morgen 10:00 uur)
12. Preventieve maatregelen: valpreventieprotocol herzien, losliggende matjes verwijderen
13. Incident bespreken in team-overleg (gepland: volgende week dinsdag)
14. Melding IGJ binnen 3 dagen (verantwoordelijke: Kwaliteitsfunctionaris)
15. Schriftelijke terugkoppeling naar familie na diagnose
16. Dossier afsluiten na volledige afhandeling, evaluatie en follow-up medische gegevens''',
				rapportages: [
					RapportageEntry(
						id: 'R1',
						auteur: 'Sophie van Dijk',
						type: 'update',
						timestamp: now - 432000000,
						beschrijving: 'Incident gemeld. Mevrouw De Jong aangetroffen op grond naast bed. Client bij bewustzijn en aanspreekbaar. Niet verplaatst. Dienstdoende verpleegkundige gebeld.',
					),
					RapportageEntry(
						id: 'R2',
						auteur: 'Linda Bakker',
						type: 'observatie',
						timestamp: now - 431700000,
						beschrijving: 'Ter plaatse bij client. Volledige ABCDE check uitgevoerd. Vitale functies gemeten en gedocumenteerd. Sterke verdenking op heupfractuur rechts op basis van pijnklachten en beperkte mobiliteit. Client kan been niet belasten. Besloten tot ambulancevervoer naar SEH.',
					),
					RapportageEntry(
						id: 'R3',
						auteur: 'Linda Bakker',
						type: 'actie',
						timestamp: now - 431100000,
						beschrijving: 'Pijnbestrijding toegediend: Paracetamol 1000mg oraal om 14:30 uur. Client gaf aan pijn iets draaglijker te vinden (VAS 7->6). Dekens aangebracht voor warmte. Client gerustgesteld en uitgelegd dat ambulance onderweg is.',
					),
					RapportageEntry(
						id: 'R4',
						auteur: 'Sophie van Dijk',
						type: 'actie',
						timestamp: now - 430800000,
						beschrijving: 'Dochter van client telefonisch geinformeerd (mevr. A. de Jong-Peters, 06-12345678). Zij komt direct naar ziekenhuis. Heb haar uitgelegd wat er is gebeurd en dat moeder naar SEH gaat voor onderzoek. Dochter maakte zich zorgen maar was dankbaar voor snelle actie.',
					),
					RapportageEntry(
						id: 'R5',
						auteur: 'Linda Bakker',
						type: 'actie',
						timestamp: now - 430200000,
						beschrijving: 'Ambulance gearriveerd om 14:45 uur. Overdracht gedaan aan ambulancepersoneel. Volledige incident rapportage, medicatielijst en ABCDE-observaties meegegeven. Client onder begeleiding met spineboard verplaatst naar brancard. Transport naar SEH Medisch Centrum Zuid. Contactgegevens uitgewisseld voor terugkoppeling.',
					),
					RapportageEntry(
						id: 'R6',
						auteur: 'Linda Bakker',
						type: 'update',
						timestamp: now - 426600000,
						beschrijving: 'SEH gebeld voor update (16:00 uur). Rontgenfoto\'s zijn gemaakt. Wachten op uitslag radioloog. Mevrouw De Jong is bij familie op SEH. Pijnbestrijding is aangepast, zij krijgt nu sterkere pijnstilling via infuus. Verdere update volgt na consult orthopeed.',
					),
					RapportageEntry(
						id: 'R7',
						auteur: 'Linda Bakker',
						type: 'update',
						timestamp: now - 421200000,
						beschrijving: 'Update ontvangen van dochter (18:10 uur): Diagnose bevestigd - Fractuur collum femoris rechts (heupfractuur). Mevrouw De Jong wordt opgenomen voor operatie morgenochtend. Orthopedisch chirurg heeft uitgelegd dat het een gedeeltelijke heupprothese wordt. Familie is bij haar. Zij wordt vannacht geobserveerd op chirurgische afdeling.',
					),
					RapportageEntry(
						id: 'R8',
						auteur: 'Mark Janssen',
						type: 'actie',
						timestamp: now - 417600000,
						beschrijving: 'Interne veiligheidscheck uitgevoerd in kamer 24B. Losliggend matje verwijderd (was geen antislip matje). Valrisico-inventarisatie gestart. Alle soortgelijke matjes op afdeling gecontroleerd. 3 andere kamers hadden ook losse matjes zonder antislip - deze zijn vervangen. Incident-analyse sessie gepland voor donderdag 10:00 uur met betrokken medewerkers.',
					),
					RapportageEntry(
						id: 'R9',
						auteur: 'Sandra Vermeulen',
						type: 'actie',
						timestamp: now - 345600000,
						beschrijving: 'IGJ melding ingediend via Meldportaal (Meldingnummer: IGJ-2024-987654). Categorie: Calamiteit conform artikel 11 lid 1 Wkkgz. Alle benodigde documentatie toegevoegd: incident rapport, SOAP rapportage, foto\'s, timeline, ABCDE-observaties. Interne risico-analyse en preventiemaatregelen gedocumenteerd. Bevestiging van ontvangst IGJ verwacht binnen 5 werkdagen.',
					),
					RapportageEntry(
						id: 'R10',
						auteur: 'Linda Bakker',
						type: 'update',
						timestamp: now - 338400000,
						beschrijving: 'Update van ziekenhuis ontvangen: Operatie succesvol verlopen vanmorgen. Mevrouw De Jong heeft een gedeeltelijke heupprothese gekregen. Operatie duurde 1,5 uur. Zij is nu op recovery en maakt het naar omstandigheden goed. Verwachte opnameduur 5-7 dagen, daarna revalidatie traject. Familie is bij haar geweest en zij was opgelucht. Fysiotherapeut start morgen met mobilisatie.',
					),
					RapportageEntry(
						id: 'R11',
						auteur: 'Mark Janssen',
						type: 'actie',
						timestamp: now - 259200000,
						beschrijving: 'Incident-evaluatie sessie gehouden met Sophie van Dijk en Linda Bakker. Besproken: acute handelingen waren correct en volgens protocol. Snelle detectie en professionele reactie hebben mogelijk ergere gevolgen voorkomen. Aandachtspunten: duizeligheidsklachten waren niet eerder gemeld - belang van proactieve monitoring benadrukt. Alle medewerkers krijgen refresher training valpreventie (gepland volgende maand).',
					),
					RapportageEntry(
						id: 'R12',
						auteur: 'Linda Bakker',
						type: 'afronding',
						timestamp: now - 86400000,
						beschrijving: 'Telefonisch contact met dochter: Mevrouw De Jong is overgeplaatst naar revalidatiecentrum "De Triangel" voor verdere revalidatie en fysiotherapie. Zij maakt goede vorderingen en kan al met hulp korte afstanden lopen. Verwachting is dat zij over 3-4 weken weer terug kan keren naar onze locatie. Familie is tevreden over de zorg en snelle hulp tijdens incident. Afspraak gemaakt voor huisbezoek zodra zij terug is om zorgplan te evalueren en valpreventie maatregelen te bespreken. Incident wordt besproken in team-overleg dinsdag a.s.',
					),
				],
			),
			SoapRapportage(
				id: 'SOAP-2026-002',
				category: 'facilitair',
				severity: 'Middel',
				status: 'concept',
				location: 'Gang B3',
				reporter: 'R. Peters',
				timestamp: now - 10800000,
				subjectief: 'Melding van natte vloer en bijna-uitglijder nabij pantry.',
				objectief: 'Waterplas van ongeveer 1.5 meter, geen waarschuwingsbord aanwezig.',
				analyse: 'Risico op valincident voor bewoners en personeel.',
				plan: 'Schoonmaak direct ingeschakeld, antislipborden geplaatst, oorzaak lekkage onderzoeken.',
				rapportages: [
					RapportageEntry(
						id: 'R4',
						auteur: 'R. Peters',
						type: 'observatie',
						timestamp: now - 10400000,
						beschrijving: 'Lekkage vastgesteld bij vaatwasser-afvoer.',
					),
					RapportageEntry(
						id: 'R5',
						auteur: 'Facilitair Team',
						type: 'actie',
						timestamp: now - 9800000,
						beschrijving: 'Afvoer tijdelijk afgesloten en vloer gereinigd.',
					),
				],
			),
			SoapRapportage(
				id: 'SOAP-2026-003',
				category: 'zorg',
				severity: 'Laag',
				status: 'definitief',
				location: 'Huiskamer C1',
				reporter: 'L. Smits',
				timestamp: now - 86400000,
				subjectief: 'Bewoner gaf aan lichte duizeligheid te ervaren bij opstaan.',
				objectief: 'Bloeddruk 110/70, pols 78, geen val of letsel geconstateerd.',
				analyse: 'Orthostatische reactie waarschijnlijk door snelle houdingwissel.',
				plan: 'Langzaam mobiliseren, vochtinname monitoren en extra observatie tijdens ochtendzorg.',
				rapportages: [
					RapportageEntry(
						id: 'R6',
						auteur: 'L. Smits',
						type: 'observatie',
						timestamp: now - 85200000,
						beschrijving: 'Cliënt herstelde binnen 10 minuten en kon zelfstandig lopen.',
					),
					RapportageEntry(
						id: 'R7',
						auteur: 'Avonddienst',
						type: 'afronding',
						timestamp: now - 79200000,
						beschrijving: 'Geen nieuwe klachten gemeld, rapportage afgesloten.',
					),
				],
			),
			SoapRapportage(
				id: 'SOAP-2026-004',
				category: 'facilitair',
				severity: 'Hoog',
				status: 'definitief',
				location: 'Technische ruimte D0',
				reporter: 'N. Vermeer',
				timestamp: now - 5400000,
				subjectief: 'Sterke brandlucht gemeld door nachtdienst in technische ruimte.',
				objectief: 'Oververhitte verdeelkast, zichtbare verkleuring op kabelmantel.',
				analyse: 'Acute kans op kortsluiting en uitval kritische installaties.',
				plan: 'Stroomkring geïsoleerd, externe storingsdienst gealarmeerd, brandwacht ingesteld.',
				rapportages: [
					RapportageEntry(
						id: 'R8',
						auteur: 'N. Vermeer',
						type: 'update',
						timestamp: now - 5100000,
						beschrijving: 'Hoofdschakelaar van betrokken groep uitgeschakeld.',
					),
					RapportageEntry(
						id: 'R9',
						auteur: 'Storingsdienst Delta',
						type: 'actie',
						timestamp: now - 4200000,
						beschrijving: 'Beschadigde component vervangen en thermische meting uitgevoerd.',
					),
				],
			),
			SoapRapportage(
				id: 'SOAP-2026-005',
				category: 'zorg',
				severity: 'Middel',
				status: 'concept',
				location: 'Kamer E2.14',
				reporter: 'S. van Dijk',
				timestamp: now - 172800000,
				subjectief: 'Familie meldt verminderde eetlust en sombere stemming bij cliënt.',
				objectief: 'Cliënt at 30% van maaltijd, trok zich terug na bezoekuur.',
				analyse: 'Mogelijke reactie op recente medicatiewijziging en vermoeidheid.',
				plan: 'Dieetlijst evalueren, psycholoog consulteren en eetmomenten begeleiden.',
				rapportages: [
					RapportageEntry(
						id: 'R10',
						auteur: 'S. van Dijk',
						type: 'observatie',
						timestamp: now - 171000000,
						beschrijving: 'Cliënt nam wel soep en toetje in rustige setting.',
					),
				],
			),
			SoapRapportage(
				id: 'SOAP-2026-006',
				category: 'facilitair',
				severity: 'Laag',
				status: 'definitief',
				location: 'Tuinzijde ingang',
				reporter: 'J. Koster',
				timestamp: now - 259200000,
				subjectief: 'Bewegwijzering naar bezoekersingang is slecht zichtbaar in de avond.',
				objectief: 'Eén lamp defect, contrast op informatiebord beperkt leesbaar.',
				analyse: 'Laag veiligheidsrisico, maar kans op verwarring bij bezoekers.',
				plan: 'Nieuwe LED verlichting plaatsen en bord opnieuw bestickeren met hoog contrast.',
				rapportages: [
					RapportageEntry(
						id: 'R11',
						auteur: 'J. Koster',
						type: 'afronding',
						timestamp: now - 252000000,
						beschrijving: 'Nieuwe lamp geplaatst en routeborden gecontroleerd.',
					),
				],
			),
		];
	}

	List<SoapRapportage> get _filteredRapportages {
		final query = _searchController.text.toLowerCase();
		return _rapportages.where((r) {
			final matchesSearch =
					r.subjectief.toLowerCase().contains(query) ||
					r.location.toLowerCase().contains(query) ||
					r.reporter.toLowerCase().contains(query);
			final matchesCategory = _filterCategory == 'all' || r.category == _filterCategory;
			final matchesSeverity = _filterSeverity == 'all' || r.severity == _filterSeverity;
			return matchesSearch && matchesCategory && matchesSeverity;
		}).toList();
	}

	Color _severityColor(String severity) {
		switch (severity) {
			case 'Hoog':
				return Colors.red;
			case 'Middel':
				return Colors.orange;
			case 'Laag':
				return Colors.green;
			default:
				return Colors.grey;
		}
	}

	IconData _categoryIcon(String category) {
		return category == 'facilitair' ? Icons.apartment : Icons.favorite;
	}

	String _formatDate(int timestamp) {
		final dt = DateTime.fromMillisecondsSinceEpoch(timestamp);
		return '${dt.day.toString().padLeft(2, '0')}-${dt.month.toString().padLeft(2, '0')}-${dt.year} ${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}';
	}

	Color _entryTypeColor(String type) {
		switch (type) {
			case 'update':
				return Colors.blue;
			case 'actie':
				return Colors.green;
			case 'observatie':
				return Colors.purple;
			case 'afronding':
				return Colors.orange;
			default:
				return Colors.grey;
		}
	}

	Map<String, int> get _stats {
		return {
			'total': _rapportages.length,
			'facilitair': _rapportages.where((r) => r.category == 'facilitair').length,
			'zorg': _rapportages.where((r) => r.category == 'zorg').length,
			'hoog': _rapportages.where((r) => r.severity == 'Hoog').length,
		};
	}

	void _addEntry() {
		if (_selectedRapportage == null || _newEntryController.text.trim().isEmpty) {
			return;
		}

		final selected = _selectedRapportage!;
		final idx = _rapportages.indexWhere((r) => r.id == selected.id);
		if (idx == -1) {
			return;
		}

		final updatedEntries = [..._rapportages[idx].rapportages];
		updatedEntries.add(
			RapportageEntry(
				id: DateTime.now().microsecondsSinceEpoch.toString(),
				auteur: 'M. Jansen',
				type: 'actie',
				timestamp: DateTime.now().millisecondsSinceEpoch,
				beschrijving: _newEntryController.text.trim(),
			),
		);

		final updated = SoapRapportage(
			id: _rapportages[idx].id,
			category: _rapportages[idx].category,
			severity: _rapportages[idx].severity,
			status: _rapportages[idx].status,
			location: _rapportages[idx].location,
			reporter: _rapportages[idx].reporter,
			timestamp: _rapportages[idx].timestamp,
			subjectief: _rapportages[idx].subjectief,
			objectief: _rapportages[idx].objectief,
			analyse: _rapportages[idx].analyse,
			plan: _rapportages[idx].plan,
			rapportages: updatedEntries,
		);

		setState(() {
			_rapportages[idx] = updated;
			_selectedRapportage = updated;
			_newEntryController.clear();
			_showAddRapportage = false;
		});
	}

	void _deleteEntry(String entryId) {
		if (_selectedRapportage == null) {
			return;
		}

		final selected = _selectedRapportage!;
		final idx = _rapportages.indexWhere((r) => r.id == selected.id);
		if (idx == -1) {
			return;
		}

		final updatedEntries = _rapportages[idx].rapportages.where((e) => e.id != entryId).toList();

		final updated = SoapRapportage(
			id: _rapportages[idx].id,
			category: _rapportages[idx].category,
			severity: _rapportages[idx].severity,
			status: _rapportages[idx].status,
			location: _rapportages[idx].location,
			reporter: _rapportages[idx].reporter,
			timestamp: _rapportages[idx].timestamp,
			subjectief: _rapportages[idx].subjectief,
			objectief: _rapportages[idx].objectief,
			analyse: _rapportages[idx].analyse,
			plan: _rapportages[idx].plan,
			rapportages: updatedEntries,
		);

		setState(() {
			_rapportages[idx] = updated;
			_selectedRapportage = updated;
		});
	}

	@override
	Widget build(BuildContext context) {
		return LayoutPage(
			child: _selectedRapportage == null ? _buildListView() : _buildDetailView(_selectedRapportage!),
		);
	}

	Widget _buildListView() {
		final results = _filteredRapportages;
		final theme = Theme.of(context);
		final stats = _stats;

		return SingleChildScrollView(
			padding: const EdgeInsets.all(16),
			child: Column(
				crossAxisAlignment: CrossAxisAlignment.start,
				children: [
					Text(
						'SOAP Rapportages',
						style: theme.textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.w800),
					),
					const SizedBox(height: 8),
					Text(
						'Bekijk en beheer alle incidentrapportages',
						style: theme.textTheme.bodyMedium?.copyWith(color: Colors.black54),
					),
					const SizedBox(height: 16),
					Card(
						elevation: 6,
						shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
						child: Padding(
							padding: const EdgeInsets.all(12),
							child: Column(
								children: [
									TextField(
										controller: _searchController,
										decoration: InputDecoration(
											prefixIcon: Icon(Icons.search),
											hintText: 'Zoek in rapportages...',
											filled: true,
											fillColor: const Color(0xFFF8FAFC),
											border: OutlineInputBorder(
												borderRadius: BorderRadius.circular(12),
												borderSide: BorderSide.none,
											),
										),
										onChanged: (_) => setState(() {}),
									),
									const SizedBox(height: 10),
									Row(
										children: [
											Expanded(
												child: DropdownButtonFormField<String>(
													initialValue: _filterCategory,
													decoration: const InputDecoration(labelText: 'Categorie'),
													items: const [
														DropdownMenuItem(value: 'all', child: Text('Alles')),
														DropdownMenuItem(value: 'facilitair', child: Text('Facilitair')),
														DropdownMenuItem(value: 'zorg', child: Text('Zorg')),
													],
													onChanged: (value) => setState(() => _filterCategory = value ?? 'all'),
												),
											),
											const SizedBox(width: 10),
											Expanded(
												child: DropdownButtonFormField<String>(
													initialValue: _filterSeverity,
													decoration: const InputDecoration(labelText: 'Prioriteit'),
													items: const [
														DropdownMenuItem(value: 'all', child: Text('Alles')),
														DropdownMenuItem(value: 'Laag', child: Text('Laag')),
														DropdownMenuItem(value: 'Middel', child: Text('Middel')),
														DropdownMenuItem(value: 'Hoog', child: Text('Hoog')),
													],
													onChanged: (value) => setState(() => _filterSeverity = value ?? 'all'),
												),
											),
										],
									),
								],
							),
						),
					),
					const SizedBox(height: 12),
					Row(
						children: [
							Expanded(
								child: _statCard('Totaal', stats['total']!, const Color(0xFF1D4ED8), Icons.assessment),
							),
							const SizedBox(width: 8),
							Expanded(
								child: _statCard('Facilitair', stats['facilitair']!, const Color(0xFF0369A1), Icons.apartment),
							),
							const SizedBox(width: 8),
							Expanded(
								child: _statCard('Zorg', stats['zorg']!, const Color(0xFFBE185D), Icons.favorite),
							),
						],
					),
					const SizedBox(height: 8),
					Container(
						padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
						decoration: BoxDecoration(
							color: const Color(0xFFF1F5F9),
							borderRadius: BorderRadius.circular(10),
						),
						child: Row(
							children: [
								const Icon(Icons.insights, size: 18, color: Color(0xFF334155)),
								const SizedBox(width: 8),
								Text('${results.length} rapportage(s) gevonden'),
								const Spacer(),
								if (stats['hoog']! > 0)
									Text(
										'${stats['hoog']} hoog',
										style: const TextStyle(color: Colors.red, fontWeight: FontWeight.w700),
									),
							],
						),
					),
					const SizedBox(height: 12),
					if (results.isEmpty)
						Card(
							elevation: 2,
							shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
							child: const Padding(
								padding: EdgeInsets.all(24),
								child: Center(child: Text('Geen rapportages gevonden.')),
							),
						)
					else
						...results.map(
							(r) => Card(
								elevation: 5,
								shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
								margin: const EdgeInsets.only(bottom: 12),
								child: InkWell(
									borderRadius: BorderRadius.circular(16),
									onTap: () => setState(() => _selectedRapportage = r),
									child: Padding(
										padding: const EdgeInsets.all(14),
										child: Row(
											children: [
												Container(
													width: 48,
													height: 48,
													decoration: BoxDecoration(
														gradient: LinearGradient(
															colors: r.category == 'facilitair'
																? const [Color(0xFF2563EB), Color(0xFF1D4ED8)]
																: const [Color(0xFFDB2777), Color(0xFFBE185D)],
														),
														borderRadius: BorderRadius.circular(14),
													),
													child: Icon(_categoryIcon(r.category), color: Colors.white),
												),
												const SizedBox(width: 12),
												Expanded(
													child: Column(
														crossAxisAlignment: CrossAxisAlignment.start,
														children: [
															Text(
																r.category == 'facilitair' ? 'Facilitaire Melding' : 'Zorg Incident',
																style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
															),
															const SizedBox(height: 4),
															Text(
																r.subjectief,
																maxLines: 2,
																overflow: TextOverflow.ellipsis,
															),
															const SizedBox(height: 8),
															Wrap(
																spacing: 6,
																runSpacing: 6,
																children: [
																	Chip(
																		label: Text(r.severity),
																		backgroundColor: _severityColor(r.severity).withValues(alpha: 0.14),
																	),
																	Chip(label: Text(r.location)),
																	Chip(label: Text(r.reporter)),
																],
															),
														],
													),
												),
												const Icon(Icons.chevron_right),
											],
										),
									),
								),
							),
						),
				],
			),
		);
	}

	Widget _buildDetailView(SoapRapportage r) {
		final theme = Theme.of(context);
		final isFacilitair = r.category == 'facilitair';
		return SingleChildScrollView(
			padding: const EdgeInsets.all(16),
			child: Column(
				crossAxisAlignment: CrossAxisAlignment.start,
				children: [
					TextButton.icon(
						onPressed: () => setState(() => _selectedRapportage = null),
						icon: const Icon(Icons.arrow_back),
						label: const Text('Terug naar overzicht'),
					),
					const SizedBox(height: 8),
					Wrap(
						spacing: 8,
						runSpacing: 8,
						children: [
							FilledButton.icon(
								onPressed: () {
									ScaffoldMessenger.of(context).showSnackBar(
										const SnackBar(content: Text('PDF export komt eraan')),
									);
								},
								icon: const Icon(Icons.download),
								label: const Text('PDF'),
							),
							OutlinedButton.icon(
								onPressed: () {
									ScaffoldMessenger.of(context).showSnackBar(
										const SnackBar(content: Text('E-mail functie komt eraan')),
									);
								},
								icon: const Icon(Icons.mail_outline),
								label: const Text('Email'),
							),
							OutlinedButton.icon(
								onPressed: () {
									ScaffoldMessenger.of(context).showSnackBar(
										const SnackBar(content: Text('Print functie komt eraan')),
									);
								},
								icon: const Icon(Icons.print_outlined),
								label: const Text('Print'),
							),
						],
					),
					const SizedBox(height: 10),
					Card(
						elevation: 6,
						shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
						child: Padding(
							padding: const EdgeInsets.all(16),
							child: Column(
								crossAxisAlignment: CrossAxisAlignment.start,
								children: [
									Row(
										children: [
											CircleAvatar(
												backgroundColor: isFacilitair ? const Color(0xFFDBEAFE) : const Color(0xFFFCE7F3),
												child: Icon(_categoryIcon(r.category), color: isFacilitair ? const Color(0xFF1D4ED8) : const Color(0xFFBE185D)),
											),
											const SizedBox(width: 12),
											Expanded(
												child: Text(
													r.category == 'facilitair' ? 'Facilitaire Melding' : 'Zorg Incident',
													style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
												),
											),
										],
									),
									const SizedBox(height: 12),
									Wrap(
										spacing: 8,
										runSpacing: 8,
										children: [
											Chip(
												label: Text(r.id),
												backgroundColor: const Color(0xFFE2E8F0),
											),
											Chip(
												label: Text(r.severity),
												backgroundColor: _severityColor(r.severity).withValues(alpha: 0.15),
											),
											Chip(
												label: Text(r.status),
												backgroundColor: const Color(0xFFDCFCE7),
											),
											Chip(label: Text(r.location)),
											Chip(label: Text(_formatDate(r.timestamp))),
										],
									),
								],
							),
						),
					),
					const SizedBox(height: 12),
					Card(
						color: const Color(0xFFEEF2FF),
						shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
						child: const Padding(
							padding: EdgeInsets.all(12),
							child: Row(
								children: [
									Icon(Icons.verified_user, color: Color(0xFF4338CA)),
									SizedBox(width: 8),
									Expanded(
										child: Text(
											'SOAP Methodiek: Gestructureerde documentatie volgens Subjectief, Objectief, Analyse en Plan.',
											style: TextStyle(color: Color(0xFF312E81)),
										),
									),
								],
							),
						),
					),
					const SizedBox(height: 12),
					_soapCard('S', 'Subjectief', r.subjectief, Colors.blue),
					_soapCard('O', 'Objectief', r.objectief, Colors.green),
					_soapCard('A', 'Analyse', r.analyse, Colors.orange),
					_soapCard('P', 'Plan', r.plan, Colors.purple),
					const SizedBox(height: 12),
					Card(
						elevation: 5,
						shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
						child: Padding(
							padding: const EdgeInsets.all(16),
							child: Column(
								crossAxisAlignment: CrossAxisAlignment.start,
								children: [
									Row(
										mainAxisAlignment: MainAxisAlignment.spaceBetween,
										children: [
											Text(
												'Rapportages (${r.rapportages.length})',
												style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w800),
											),
											OutlinedButton.icon(
												onPressed: () {
													setState(() {
														_showAddRapportage = !_showAddRapportage;
													});
												},
												icon: const Icon(Icons.add),
												label: const Text('Nieuwe rapportage'),
											),
										],
									),
									if (_showAddRapportage) ...[
										const SizedBox(height: 10),
										TextField(
											controller: _newEntryController,
											maxLines: 4,
											decoration: InputDecoration(
												hintText: 'Beschrijf wat er gebeurd is...',
												filled: true,
												fillColor: const Color(0xFFF8FAFC),
												border: OutlineInputBorder(
													borderRadius: BorderRadius.circular(12),
												),
											),
										),
										const SizedBox(height: 8),
										Row(
											children: [
												ElevatedButton.icon(
													onPressed: _addEntry,
													icon: const Icon(Icons.check),
													label: const Text('Opslaan'),
												),
												const SizedBox(width: 8),
												OutlinedButton(
													onPressed: () {
														setState(() {
															_showAddRapportage = false;
															_newEntryController.clear();
														});
													},
													child: const Text('Annuleren'),
												),
											],
										),
									],
									const SizedBox(height: 8),
									if (r.rapportages.isEmpty)
										const Padding(
											padding: EdgeInsets.symmetric(vertical: 16),
											child: Text('Nog geen rapportages toegevoegd'),
										)
									else
										...r.rapportages.map((entry) {
											final editing = _editingEntryId == entry.id;
											return Card(
												elevation: 2,
												shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
												margin: const EdgeInsets.only(top: 10),
												child: Padding(
													padding: const EdgeInsets.all(12),
													child: Column(
														crossAxisAlignment: CrossAxisAlignment.start,
														children: [
															Row(
																children: [
																	Chip(
																		label: Text(entry.type),
																		backgroundColor: _entryTypeColor(entry.type).withValues(alpha: 0.15),
																	),
																	const SizedBox(width: 8),
																	Expanded(
																		child: Text('${entry.auteur} - ${_formatDate(entry.timestamp)}'),
																	),
																	IconButton(
																		icon: const Icon(Icons.edit),
																		onPressed: () {
																			setState(() {
																				_editingEntryId = entry.id;
																				_editEntryController.text = entry.beschrijving;
																			});
																		},
																	),
																	IconButton(
																		icon: const Icon(Icons.delete, color: Colors.red),
																		onPressed: () => _deleteEntry(entry.id),
																	),
																],
															),
															if (editing) ...[
																TextField(
																	controller: _editEntryController,
																	maxLines: 3,
																),
																const SizedBox(height: 8),
																Row(
																	children: [
																		ElevatedButton.icon(
																			onPressed: () {
																				final text = _editEntryController.text.trim();
																				if (text.isEmpty || _selectedRapportage == null) {
																					return;
																				}
																				final selected = _selectedRapportage!;
																				final idx = _rapportages.indexWhere((x) => x.id == selected.id);
																				if (idx == -1) {
																					return;
																				}
																				final entries = _rapportages[idx].rapportages.map((e) {
																					if (e.id == entry.id) {
																						return RapportageEntry(
																							id: e.id,
																							auteur: e.auteur,
																							type: e.type,
																							timestamp: e.timestamp,
																							beschrijving: text,
																						);
																					}
																					return e;
																				}).toList();

																				final updated = SoapRapportage(
																					id: _rapportages[idx].id,
																					category: _rapportages[idx].category,
																					severity: _rapportages[idx].severity,
																					status: _rapportages[idx].status,
																					location: _rapportages[idx].location,
																					reporter: _rapportages[idx].reporter,
																					timestamp: _rapportages[idx].timestamp,
																					subjectief: _rapportages[idx].subjectief,
																					objectief: _rapportages[idx].objectief,
																					analyse: _rapportages[idx].analyse,
																					plan: _rapportages[idx].plan,
																					rapportages: entries,
																				);

																				setState(() {
																					_rapportages[idx] = updated;
																					_selectedRapportage = updated;
																					_editingEntryId = null;
																					_editEntryController.clear();
																				});
																			},
																			icon: const Icon(Icons.save),
																			label: const Text('Opslaan'),
																		),
																		const SizedBox(width: 8),
																		OutlinedButton(
																			onPressed: () {
																				setState(() {
																					_editingEntryId = null;
																					_editEntryController.clear();
																				});
																			},
																			child: const Text('Annuleren'),
																		),
																	],
																),
															] else
																Padding(
																	padding: const EdgeInsets.only(top: 6),
																	child: Text(entry.beschrijving),
																),
														],
													),
												),
											);
										}),
								],
							),
						),
					),
					const SizedBox(height: 12),
					Card(
						shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
						child: Padding(
							padding: const EdgeInsets.all(12),
							child: Row(
								children: [
									Expanded(
										child: FilledButton.icon(
											onPressed: () {
												ScaffoldMessenger.of(context).showSnackBar(
													const SnackBar(content: Text('Exporteer als PDF komt eraan')),
												);
											},
											icon: const Icon(Icons.picture_as_pdf_outlined),
											label: const Text('Exporteer als PDF'),
										),
									),
									const SizedBox(width: 8),
									Expanded(
										child: OutlinedButton.icon(
											onPressed: () {
												ScaffoldMessenger.of(context).showSnackBar(
													const SnackBar(content: Text('Stuur naar e-mail komt eraan')),
												);
											},
											icon: const Icon(Icons.outgoing_mail),
											label: const Text('E-mail'),
										),
									),
								],
							),
						),
					),
				],
			),
		);
	}

	Widget _statCard(String title, int value, Color color, IconData icon) {
		return Container(
			padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
			decoration: BoxDecoration(
				color: color.withValues(alpha: 0.1),
				borderRadius: BorderRadius.circular(12),
				border: Border.all(color: color.withValues(alpha: 0.2)),
			),
			child: Row(
				children: [
					Icon(icon, color: color, size: 18),
					const SizedBox(width: 8),
					Expanded(
						child: Column(
							crossAxisAlignment: CrossAxisAlignment.start,
							children: [
								Text(title, style: TextStyle(color: color, fontSize: 11, fontWeight: FontWeight.w600)),
								Text('$value', style: TextStyle(color: color, fontSize: 18, fontWeight: FontWeight.w800)),
							],
						),
					),
				],
			),
		);
	}

	Widget _soapCard(String key, String title, String text, Color color) {
		return Card(
			elevation: 4,
			shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
			margin: const EdgeInsets.only(bottom: 12),
			child: Padding(
				padding: const EdgeInsets.all(16),
				child: Column(
					crossAxisAlignment: CrossAxisAlignment.start,
					children: [
						Container(
							padding: const EdgeInsets.all(10),
							decoration: BoxDecoration(
								borderRadius: BorderRadius.circular(12),
								gradient: LinearGradient(
									colors: [
										color.withValues(alpha: 0.85),
										color.withValues(alpha: 0.7),
									],
								),
							),
							child: Row(
								children: [
									CircleAvatar(backgroundColor: Colors.white24, child: Text(key, style: const TextStyle(color: Colors.white))),
									const SizedBox(width: 10),
									Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
								],
							),
						),
						const SizedBox(height: 10),
						Text(text, style: const TextStyle(height: 1.45)),
					],
				),
			),
		);
	}
}

