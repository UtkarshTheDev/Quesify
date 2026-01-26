/**
 * Comprehensive Class 12 CBSE Syllabus Data
 * Priority levels (1-5):
 * 5 = Very High (highest weightage in exams)
 * 4 = High
 * 3 = Medium
 * 2 = Low
 * 1 = Very Low
 */

export interface SyllabusEntry {
  class: '12'
  subject: string
  chapter: string
  topics: string[]
  priority: number
}

export const class12Syllabus: SyllabusEntry[] = [
  // ==================== PHYSICS ====================

  // Unit 1: Electrostatics
  {
    class: '12',
    subject: 'Physics',
    chapter: 'Electric Charges and Fields',
    topics: [
      'Electric charges',
      'Conservation of charge',
      "Coulomb's law",
      'Electric field',
      'Electric field lines',
      'Electric flux',
      "Gauss's theorem",
      'Applications of Gauss theorem',
      'Electric field due to point charge',
      'Electric field due to dipole',
      'Electric field due to charged sphere',
      'Electric field due to infinite plane sheet',
      'Electric field due to uniformly charged infinite plane conductor'
    ],
    priority: 5
  },
  {
    class: '12',
    subject: 'Physics',
    chapter: 'Electrostatic Potential and Capacitance',
    topics: [
      'Electric potential',
      'Potential difference',
      'Electric potential due to point charge',
      'Electric potential due to dipole',
      'Electric potential due to system of charges',
      'Equipotential surfaces',
      'Relation between electric field and potential',
      'Potential energy',
      'Potential energy of system of charges',
      'Potential energy in external field',
      'Capacitors and capacitance',
      'Combination of capacitors',
      'Energy stored in capacitor',
      'Dielectrics and polarization',
      'Effect of dielectric on capacitance'
    ],
    priority: 5
  },

  // Unit 2: Current Electricity
  {
    class: '12',
    subject: 'Physics',
    chapter: 'Current Electricity',
    topics: [
      'Electric current',
      "Ohm's law",
      'Electrical resistance',
      'Resistivity and conductivity',
      'Temperature dependence of resistance',
      'Drift velocity',
      'Mobility',
      'Current density',
      'Series and parallel combinations of resistors',
      'Internal resistance',
      'EMF of a cell',
      'Potential difference and EMF',
      "Kirchhoff's laws",
      'Wheatstone bridge',
      'Meter bridge',
      'Potentiometer'
    ],
    priority: 5
  },

  // Unit 3: Magnetic Effects of Current
  {
    class: '12',
    subject: 'Physics',
    chapter: 'Moving Charges and Magnetism',
    topics: [
      'Biot-Savart law',
      'Magnetic field due to current element',
      'Magnetic field on axis of circular loop',
      'Ampere circuital law',
      'Magnetic field due to straight wire',
      'Magnetic field due to solenoid',
      'Magnetic field due to toroid',
      'Force on moving charge in magnetic field',
      'Lorentz force',
      'Force on current carrying conductor',
      'Force between two parallel conductors',
      'Torque on current loop',
      'Magnetic dipole moment',
      'Moving coil galvanometer'
    ],
    priority: 5
  },
  {
    class: '12',
    subject: 'Physics',
    chapter: 'Magnetism and Matter',
    topics: [
      'Bar magnet',
      'Magnetic field lines',
      'Magnetic dipole',
      'Magnetic dipole in uniform magnetic field',
      'Torque on magnetic dipole',
      "Gauss's law in magnetism",
      "Earth's magnetic field",
      'Magnetic elements',
      'Magnetization and magnetic intensity',
      'Magnetic susceptibility',
      'Diamagnetic materials',
      'Paramagnetic materials',
      'Ferromagnetic materials',
      'Hysteresis'
    ],
    priority: 3
  },

  // Unit 4: Electromagnetic Induction
  {
    class: '12',
    subject: 'Physics',
    chapter: 'Electromagnetic Induction',
    topics: [
      "Faraday's laws of electromagnetic induction",
      "Lenz's law",
      'Induced EMF and current',
      'Motional EMF',
      'Energy consideration',
      'Eddy currents',
      'Self-inductance',
      'Mutual inductance',
      'Inductance of solenoid',
      'AC generator',
      'Transformer',
      'Energy stored in inductor'
    ],
    priority: 5
  },
  {
    class: '12',
    subject: 'Physics',
    chapter: 'Alternating Current',
    topics: [
      'AC voltage and current',
      'Peak and RMS value',
      'Reactance and impedance',
      'AC circuit with resistor',
      'AC circuit with inductor',
      'AC circuit with capacitor',
      'LCR series circuit',
      'Resonance in LCR circuit',
      'Quality factor',
      'Power in AC circuit',
      'Power factor',
      'LC oscillations',
      'Transformers'
    ],
    priority: 4
  },

  // Unit 5: Electromagnetic Waves
  {
    class: '12',
    subject: 'Physics',
    chapter: 'Electromagnetic Waves',
    topics: [
      'Displacement current',
      'Electromagnetic waves',
      'Properties of electromagnetic waves',
      'Transverse nature',
      'Speed of electromagnetic waves',
      'Electromagnetic spectrum',
      'Radio waves',
      'Microwaves',
      'Infrared waves',
      'Visible light',
      'Ultraviolet rays',
      'X-rays',
      'Gamma rays'
    ],
    priority: 2
  },

  // Unit 6: Optics
  {
    class: '12',
    subject: 'Physics',
    chapter: 'Ray Optics and Optical Instruments',
    topics: [
      'Reflection of light',
      'Laws of reflection',
      'Spherical mirrors',
      'Mirror formula',
      'Magnification',
      'Refraction of light',
      'Laws of refraction',
      "Snell's law",
      'Refractive index',
      'Total internal reflection',
      'Critical angle',
      'Refraction at spherical surface',
      'Lens formula',
      'Lens maker formula',
      'Power of lens',
      'Combination of thin lenses',
      'Refraction through prism',
      'Dispersion',
      'Deviation',
      'Rainbow',
      'Scattering of light',
      'Simple microscope',
      'Compound microscope',
      'Astronomical telescope',
      'Terrestrial telescope',
      'Reflecting telescope'
    ],
    priority: 5
  },
  {
    class: '12',
    subject: 'Physics',
    chapter: 'Wave Optics',
    topics: [
      'Wavefront',
      "Huygens' principle",
      'Reflection using Huygens principle',
      'Refraction using Huygens principle',
      'Coherent sources',
      'Interference of light',
      "Young's double slit experiment",
      'Fringe width',
      'Conditions for interference',
      'Diffraction',
      'Single slit diffraction',
      'Diffraction grating',
      'Resolving power',
      'Polarization',
      'Plane polarized light',
      "Brewster's law",
      'Malus law'
    ],
    priority: 4
  },

  // Unit 7: Dual Nature of Matter
  {
    class: '12',
    subject: 'Physics',
    chapter: 'Dual Nature of Radiation and Matter',
    topics: [
      'Photoelectric effect',
      "Einstein's photoelectric equation",
      'Work function',
      'Threshold frequency',
      'Stopping potential',
      "Planck's quantum theory",
      'Particle nature of light',
      'Wave nature of matter',
      'de Broglie hypothesis',
      'de Broglie wavelength',
      'Davisson-Germer experiment'
    ],
    priority: 4
  },

  // Unit 8: Atoms and Nuclei
  {
    class: '12',
    subject: 'Physics',
    chapter: 'Atoms',
    topics: [
      'Alpha particle scattering',
      "Rutherford's model of atom",
      "Bohr's model of hydrogen atom",
      'Energy levels',
      'Line spectra',
      'Hydrogen spectrum',
      'Balmer series',
      'Lyman series',
      'Paschen series',
      'Brackett series',
      'Pfund series',
      'Ionization energy',
      'Excitation energy'
    ],
    priority: 3
  },
  {
    class: '12',
    subject: 'Physics',
    chapter: 'Nuclei',
    topics: [
      'Composition of nucleus',
      'Atomic mass',
      'Mass number',
      'Size of nucleus',
      'Mass-energy relation',
      'Mass defect',
      'Binding energy',
      'Binding energy per nucleon',
      'Nuclear force',
      'Radioactivity',
      'Alpha decay',
      'Beta decay',
      'Gamma decay',
      'Radioactive decay law',
      'Half-life',
      'Mean life',
      'Nuclear fission',
      'Nuclear fusion',
      'Nuclear reactor'
    ],
    priority: 4
  },

  // Unit 9: Electronic Devices
  {
    class: '12',
    subject: 'Physics',
    chapter: 'Semiconductor Electronics',
    topics: [
      'Intrinsic semiconductors',
      'Extrinsic semiconductors',
      'p-type semiconductor',
      'n-type semiconductor',
      'p-n junction',
      'Forward bias',
      'Reverse bias',
      'p-n junction diode',
      'V-I characteristics',
      'Diode as rectifier',
      'Half wave rectifier',
      'Full wave rectifier',
      'Junction transistor',
      'Transistor action',
      'Transistor characteristics',
      'Transistor as amplifier',
      'Transistor as switch',
      'Logic gates',
      'AND gate',
      'OR gate',
      'NOT gate',
      'NAND gate',
      'NOR gate'
    ],
    priority: 4
  },

  // Unit 10: Communication Systems
  {
    class: '12',
    subject: 'Physics',
    chapter: 'Communication Systems',
    topics: [
      'Communication system',
      'Analog and digital signals',
      'Bandwidth',
      'Modulation',
      'Amplitude modulation',
      'Frequency modulation',
      'Phase modulation',
      'Demodulation',
      'Propagation of electromagnetic waves',
      'Ground wave propagation',
      'Sky wave propagation',
      'Space wave propagation'
    ],
    priority: 2
  },

  // ==================== CHEMISTRY ====================

  // Unit 1: Solid State
  {
    class: '12',
    subject: 'Chemistry',
    chapter: 'The Solid State',
    topics: [
      'Classification of solids',
      'Crystalline and amorphous solids',
      'Unit cell',
      'Crystal lattice',
      'Types of unit cells',
      'Simple cubic',
      'Body-centered cubic',
      'Face-centered cubic',
      'Packing efficiency',
      'Close packing',
      'Hexagonal close packing',
      'Cubic close packing',
      'Coordination number',
      'Voids',
      'Tetrahedral voids',
      'Octahedral voids',
      'Ionic solids',
      'NaCl structure',
      'ZnS structure',
      'CsCl structure',
      'CaF2 structure',
      'Imperfections in solids',
      'Point defects',
      'Schottky defect',
      'Frenkel defect',
      'Electrical properties',
      'Magnetic properties'
    ],
    priority: 3
  },

  // Unit 2: Solutions
  {
    class: '12',
    subject: 'Chemistry',
    chapter: 'Solutions',
    topics: [
      'Types of solutions',
      'Concentration terms',
      'Molarity',
      'Molality',
      'Mole fraction',
      'Mass percentage',
      'Volume percentage',
      'Parts per million',
      "Raoult's law",
      'Ideal and non-ideal solutions',
      'Positive deviation',
      'Negative deviation',
      'Vapour pressure',
      'Colligative properties',
      'Relative lowering of vapour pressure',
      'Elevation of boiling point',
      'Depression of freezing point',
      'Osmotic pressure',
      "Van't Hoff factor",
      'Abnormal molar mass'
    ],
    priority: 5
  },

  // Unit 3: Electrochemistry
  {
    class: '12',
    subject: 'Chemistry',
    chapter: 'Electrochemistry',
    topics: [
      'Electrochemical cells',
      'Galvanic cells',
      'Electrolytic cells',
      'Electrode potential',
      'Standard electrode potential',
      'Nernst equation',
      'Relation between cell potential and Gibbs energy',
      'Conductance',
      'Specific conductance',
      'Molar conductance',
      'Equivalent conductance',
      "Kohlrausch's law",
      'Electrolysis',
      "Faraday's laws of electrolysis",
      'Batteries',
      'Primary batteries',
      'Secondary batteries',
      'Fuel cells',
      'Corrosion',
      'Prevention of corrosion'
    ],
    priority: 5
  },

  // Unit 4: Chemical Kinetics
  {
    class: '12',
    subject: 'Chemistry',
    chapter: 'Chemical Kinetics',
    topics: [
      'Rate of reaction',
      'Average rate',
      'Instantaneous rate',
      'Factors affecting rate',
      'Rate law',
      'Rate constant',
      'Order of reaction',
      'Molecularity',
      'Zero order reaction',
      'First order reaction',
      'Second order reaction',
      'Pseudo first order reaction',
      'Half-life',
      'Integrated rate equations',
      'Collision theory',
      'Activation energy',
      'Arrhenius equation',
      'Effect of temperature on rate',
      'Catalysis',
      'Homogeneous catalysis',
      'Heterogeneous catalysis'
    ],
    priority: 5
  },

  // Unit 5: Surface Chemistry
  {
    class: '12',
    subject: 'Chemistry',
    chapter: 'Surface Chemistry',
    topics: [
      'Adsorption',
      'Physisorption',
      'Chemisorption',
      'Adsorption isotherms',
      'Freundlich adsorption isotherm',
      'Langmuir adsorption isotherm',
      'Applications of adsorption',
      'Catalysis',
      'Homogeneous catalysis',
      'Heterogeneous catalysis',
      'Enzyme catalysis',
      'Colloids',
      'Classification of colloids',
      'Lyophilic colloids',
      'Lyophobic colloids',
      'Multimolecular colloids',
      'Macromolecular colloids',
      'Associated colloids',
      'Emulsions',
      'Tyndall effect',
      'Brownian movement',
      'Electrophoresis',
      'Coagulation',
      'Hardy-Schulze rule'
    ],
    priority: 3
  },

  // Unit 6: General Principles of Metallurgy
  {
    class: '12',
    subject: 'Chemistry',
    chapter: 'General Principles and Processes of Isolation of Elements',
    topics: [
      'Occurrence of metals',
      'Minerals and ores',
      'Concentration of ores',
      'Hydraulic washing',
      'Magnetic separation',
      'Froth flotation',
      'Leaching',
      'Extraction of metals',
      'Reduction',
      'Calcination',
      'Roasting',
      'Smelting',
      'Refining of metals',
      'Electrolytic refining',
      'Zone refining',
      'Vapour phase refining',
      'Thermodynamic principles',
      'Ellingham diagram',
      'Electrochemical principles',
      'Oxidation and reduction'
    ],
    priority: 2
  },

  // Unit 7: p-Block Elements
  {
    class: '12',
    subject: 'Chemistry',
    chapter: 'The p-Block Elements (Group 15)',
    topics: [
      'Group 15 elements',
      'Electronic configuration',
      'Occurrence',
      'Properties of nitrogen',
      'Preparation of ammonia',
      'Properties of ammonia',
      'Oxides of nitrogen',
      'Nitric acid',
      'Preparation of nitric acid',
      'Properties of nitric acid',
      'Phosphorus allotropes',
      'Phosphine',
      'Phosphorus halides',
      'Oxoacids of phosphorus'
    ],
    priority: 3
  },
  {
    class: '12',
    subject: 'Chemistry',
    chapter: 'The p-Block Elements (Group 16)',
    topics: [
      'Group 16 elements',
      'Electronic configuration',
      'Occurrence',
      'Trends in properties',
      'Dioxygen preparation',
      'Properties of dioxygen',
      'Ozone preparation',
      'Properties of ozone',
      'Structure of ozone',
      'Sulphur allotropes',
      'Sulphur dioxide',
      'Sulphuric acid',
      'Contact process',
      'Properties of sulphuric acid'
    ],
    priority: 3
  },
  {
    class: '12',
    subject: 'Chemistry',
    chapter: 'The p-Block Elements (Group 17)',
    topics: [
      'Group 17 elements',
      'Halogens',
      'Electronic configuration',
      'Occurrence',
      'Trends in properties',
      'Chlorine preparation',
      'Properties of chlorine',
      'Hydrogen chloride',
      'Hydrochloric acid',
      'Interhalogen compounds',
      'Oxoacids of halogens',
      'Bleaching powder',
      'Anomalous behaviour of fluorine'
    ],
    priority: 3
  },
  {
    class: '12',
    subject: 'Chemistry',
    chapter: 'The p-Block Elements (Group 18)',
    topics: [
      'Group 18 elements',
      'Noble gases',
      'Electronic configuration',
      'Occurrence',
      'Trends in properties',
      'Inertness of noble gases',
      'Compounds of xenon',
      'XeF2',
      'XeF4',
      'XeF6',
      'XeO3',
      'XeOF4',
      'Uses of noble gases'
    ],
    priority: 2
  },

  // Unit 8: d and f Block Elements
  {
    class: '12',
    subject: 'Chemistry',
    chapter: 'The d and f Block Elements',
    topics: [
      'Transition elements',
      'Electronic configuration',
      'General properties',
      'Oxidation states',
      'Catalytic properties',
      'Magnetic properties',
      'Coloured compounds',
      'Formation of complexes',
      'Interstitial compounds',
      'Alloy formation',
      'Potassium dichromate',
      'Potassium permanganate',
      'Inner transition elements',
      'Lanthanoids',
      'Lanthanoid contraction',
      'Actinoids',
      'Comparison of lanthanoids and actinoids'
    ],
    priority: 4
  },

  // Unit 9: Coordination Compounds
  {
    class: '12',
    subject: 'Chemistry',
    chapter: 'Coordination Compounds',
    topics: [
      'Coordination compounds',
      'Coordination entity',
      'Central atom',
      'Ligands',
      'Coordination number',
      'Coordination sphere',
      'Coordination polyhedron',
      'Oxidation state',
      'Homoleptic complexes',
      'Heteroleptic complexes',
      'IUPAC nomenclature',
      'Isomerism in complexes',
      'Geometrical isomerism',
      'Optical isomerism',
      'Linkage isomerism',
      'Coordination isomerism',
      'Ionization isomerism',
      'Solvate isomerism',
      'Bonding in complexes',
      'Valence bond theory',
      'Crystal field theory',
      'Magnetic properties',
      'Colour in complexes',
      'Applications of coordination compounds'
    ],
    priority: 4
  },

  // Unit 10: Haloalkanes and Haloarenes
  {
    class: '12',
    subject: 'Chemistry',
    chapter: 'Haloalkanes and Haloarenes',
    topics: [
      'Classification of halogen derivatives',
      'Nomenclature',
      'Preparation of haloalkanes',
      'Preparation of haloarenes',
      'Physical properties',
      'Chemical reactions',
      'Nucleophilic substitution',
      'SN1 mechanism',
      'SN2 mechanism',
      'Elimination reactions',
      'Reaction with metals',
      'Grignard reagent',
      'Wurtz reaction',
      'Fittig reaction',
      'Wurtz-Fittig reaction',
      'Electrophilic substitution in haloarenes',
      'DDT',
      'Chloroform',
      'Iodoform',
      'Freon',
      'Environmental effects'
    ],
    priority: 4
  },

  // Unit 11: Alcohols, Phenols and Ethers
  {
    class: '12',
    subject: 'Chemistry',
    chapter: 'Alcohols, Phenols and Ethers',
    topics: [
      'Classification of alcohols',
      'Classification of phenols',
      'Classification of ethers',
      'Nomenclature',
      'Preparation of alcohols',
      'Preparation of phenols',
      'Preparation of ethers',
      'Physical properties',
      'Chemical reactions of alcohols',
      'Oxidation of alcohols',
      'Dehydration of alcohols',
      'Reaction with HX',
      'Chemical reactions of phenols',
      'Acidity of phenols',
      'Electrophilic substitution',
      'Kolbe reaction',
      'Reimer-Tiemann reaction',
      'Coupling reaction',
      'Chemical reactions of ethers',
      'Williamson synthesis',
      'Uses of alcohols, phenols and ethers'
    ],
    priority: 4
  },

  // Unit 12: Aldehydes, Ketones and Carboxylic Acids
  {
    class: '12',
    subject: 'Chemistry',
    chapter: 'Aldehydes, Ketones and Carboxylic Acids',
    topics: [
      'Nomenclature',
      'Preparation of aldehydes',
      'Preparation of ketones',
      'Preparation of carboxylic acids',
      'Physical properties',
      'Chemical reactions',
      'Nucleophilic addition',
      'Addition of HCN',
      'Addition of sodium bisulphite',
      'Addition of Grignard reagent',
      'Reduction to alcohols',
      'Oxidation',
      'Aldol condensation',
      'Cannizzaro reaction',
      'Cross aldol condensation',
      'Haloform reaction',
      'Clemmensen reduction',
      'Wolff-Kishner reduction',
      'Acidity of carboxylic acids',
      'Reactions of carboxylic acids',
      'Formation of acid derivatives',
      'Hell-Volhard-Zelinsky reaction',
      'Uses of aldehydes, ketones and carboxylic acids'
    ],
    priority: 5
  },

  // Unit 13: Organic Compounds containing Nitrogen
  {
    class: '12',
    subject: 'Chemistry',
    chapter: 'Amines',
    topics: [
      'Classification of amines',
      'Nomenclature',
      'Preparation of amines',
      'Physical properties',
      'Chemical reactions',
      'Basicity of amines',
      'Alkylation',
      'Acylation',
      'Carbylamine reaction',
      'Reaction with nitrous acid',
      'Electrophilic substitution',
      'Sandmeyer reaction',
      'Gattermann reaction',
      'Balz-Schiemann reaction',
      'Coupling reaction',
      'Distinction between primary, secondary and tertiary amines',
      'Diazonium salts'
    ],
    priority: 3
  },
  {
    class: '12',
    subject: 'Chemistry',
    chapter: 'Cyanides and Isocyanides',
    topics: [
      'Structure of cyanides',
      'Structure of isocyanides',
      'Preparation of cyanides',
      'Preparation of isocyanides',
      'Chemical reactions',
      'Hydrolysis',
      'Reduction',
      'Uses'
    ],
    priority: 2
  },

  // Unit 14: Biomolecules
  {
    class: '12',
    subject: 'Chemistry',
    chapter: 'Biomolecules',
    topics: [
      'Carbohydrates',
      'Classification of carbohydrates',
      'Monosaccharides',
      'Glucose',
      'Fructose',
      'Disaccharides',
      'Sucrose',
      'Maltose',
      'Lactose',
      'Polysaccharides',
      'Starch',
      'Cellulose',
      'Glycogen',
      'Proteins',
      'Amino acids',
      'Peptide bond',
      'Structure of proteins',
      'Denaturation of proteins',
      'Enzymes',
      'Nucleic acids',
      'DNA structure',
      'RNA structure',
      'Vitamins',
      'Hormones'
    ],
    priority: 3
  },

  // Unit 15: Polymers
  {
    class: '12',
    subject: 'Chemistry',
    chapter: 'Polymers',
    topics: [
      'Classification of polymers',
      'Natural polymers',
      'Synthetic polymers',
      'Addition polymerization',
      'Condensation polymerization',
      'Homopolymers',
      'Copolymers',
      'Thermoplastic polymers',
      'Thermosetting polymers',
      'Elastomers',
      'Fibres',
      'Polythene',
      'Polystyrene',
      'PVC',
      'Teflon',
      'Nylon',
      'Terylene',
      'Bakelite',
      'Rubber',
      'Vulcanization',
      'Biodegradable polymers'
    ],
    priority: 2
  },

  // Unit 16: Chemistry in Everyday Life
  {
    class: '12',
    subject: 'Chemistry',
    chapter: 'Chemistry in Everyday Life',
    topics: [
      'Drugs and medicines',
      'Classification of drugs',
      'Analgesics',
      'Tranquilizers',
      'Antiseptics',
      'Disinfectants',
      'Antimicrobials',
      'Antifertility drugs',
      'Antibiotics',
      'Antacids',
      'Antihistamines',
      'Chemotherapy',
      'Food preservatives',
      'Artificial sweetening agents',
      'Soaps',
      'Detergents',
      'Cleansing action'
    ],
    priority: 2
  },

  // ==================== MATHEMATICS ====================

  // Unit 1: Relations and Functions
  {
    class: '12',
    subject: 'Mathematics',
    chapter: 'Relations and Functions',
    topics: [
      'Types of relations',
      'Reflexive relation',
      'Symmetric relation',
      'Transitive relation',
      'Equivalence relation',
      'One to one function',
      'Onto function',
      'Bijective function',
      'Composite functions',
      'Inverse of a function',
      'Binary operations'
    ],
    priority: 4
  },
  {
    class: '12',
    subject: 'Mathematics',
    chapter: 'Inverse Trigonometric Functions',
    topics: [
      'Domain and range of inverse trigonometric functions',
      'Principal value',
      'Properties of inverse trigonometric functions',
      'sin⁻¹ x',
      'cos⁻¹ x',
      'tan⁻¹ x',
      'cot⁻¹ x',
      'sec⁻¹ x',
      'cosec⁻¹ x',
      'Graphs of inverse trigonometric functions',
      'Elementary properties'
    ],
    priority: 4
  },

  // Unit 2: Algebra
  {
    class: '12',
    subject: 'Mathematics',
    chapter: 'Matrices',
    topics: [
      'Types of matrices',
      'Row matrix',
      'Column matrix',
      'Square matrix',
      'Diagonal matrix',
      'Scalar matrix',
      'Identity matrix',
      'Zero matrix',
      'Symmetric matrix',
      'Skew-symmetric matrix',
      'Operations on matrices',
      'Addition of matrices',
      'Multiplication of matrices',
      'Transpose of matrix',
      'Properties of transpose',
      'Inverse of matrix',
      'Adjoint of matrix',
      'Elementary row operations',
      'Elementary column operations'
    ],
    priority: 5
  },
  {
    class: '12',
    subject: 'Mathematics',
    chapter: 'Determinants',
    topics: [
      'Determinant of a square matrix',
      'Properties of determinants',
      'Area of triangle using determinants',
      'Minors and cofactors',
      'Adjoint of a matrix',
      'Inverse of a matrix using adjoint',
      'Applications of determinants',
      'Solution of system of linear equations',
      'Consistency of system',
      'Cramers rule'
    ],
    priority: 5
  },

  // Unit 3: Calculus
  {
    class: '12',
    subject: 'Mathematics',
    chapter: 'Continuity and Differentiability',
    topics: [
      'Continuity of a function',
      'Continuity at a point',
      'Algebra of continuous functions',
      'Differentiability',
      'Relationship between continuity and differentiability',
      'Derivative of composite functions',
      'Chain rule',
      'Derivative of inverse trigonometric functions',
      'Derivative of implicit functions',
      'Derivative of exponential functions',
      'Derivative of logarithmic functions',
      'Logarithmic differentiation',
      'Parametric differentiation',
      'Second order derivatives',
      'Rolles theorem',
      'Mean value theorem'
    ],
    priority: 5
  },
  {
    class: '12',
    subject: 'Mathematics',
    chapter: 'Applications of Derivatives',
    topics: [
      'Rate of change',
      'Increasing and decreasing functions',
      'Tangents and normals',
      'Approximations',
      'Maxima and minima',
      'First derivative test',
      'Second derivative test',
      'Maximum and minimum values',
      'Simple problems on optimization'
    ],
    priority: 5
  },
  {
    class: '12',
    subject: 'Mathematics',
    chapter: 'Integrals',
    topics: [
      'Indefinite integrals',
      'Integration as anti-derivative',
      'Fundamental theorems of calculus',
      'Integration by substitution',
      'Integration by parts',
      'Integration by partial fractions',
      'Integration of trigonometric functions',
      'Integration using trigonometric identities',
      'Definite integrals',
      'Properties of definite integrals',
      'Evaluation of definite integrals',
      'Integration as limit of sum'
    ],
    priority: 5
  },
  {
    class: '12',
    subject: 'Mathematics',
    chapter: 'Applications of Integrals',
    topics: [
      'Area under curves',
      'Area between two curves',
      'Area of the region bounded by curve and line',
      'Area of the region bounded by two curves',
      'Area using integration'
    ],
    priority: 4
  },
  {
    class: '12',
    subject: 'Mathematics',
    chapter: 'Differential Equations',
    topics: [
      'Order and degree of differential equation',
      'Formation of differential equations',
      'Solution of differential equations',
      'General solution',
      'Particular solution',
      'Variable separable method',
      'Homogeneous differential equations',
      'Linear differential equations',
      'First order linear differential equations',
      'Applications of differential equations'
    ],
    priority: 4
  },

  // Unit 4: Vectors and 3D Geometry
  {
    class: '12',
    subject: 'Mathematics',
    chapter: 'Vectors',
    topics: [
      'Vectors and scalars',
      'Position vector',
      'Direction cosines',
      'Direction ratios',
      'Types of vectors',
      'Equal vectors',
      'Unit vector',
      'Zero vector',
      'Parallel vectors',
      'Collinear vectors',
      'Coplanar vectors',
      'Addition of vectors',
      'Multiplication of vector by scalar',
      'Position vector of a point',
      'Section formula',
      'Scalar product',
      'Dot product',
      'Vector product',
      'Cross product',
      'Scalar triple product',
      'Vector triple product'
    ],
    priority: 5
  },
  {
    class: '12',
    subject: 'Mathematics',
    chapter: 'Three Dimensional Geometry',
    topics: [
      'Direction cosines and direction ratios',
      'Equation of a line in space',
      'Cartesian form',
      'Vector form',
      'Angle between two lines',
      'Shortest distance between two lines',
      'Distance between parallel lines',
      'Distance between skew lines',
      'Plane',
      'Equation of plane',
      'Equation of plane passing through three points',
      'Intercept form of plane',
      'Normal form of plane',
      'Angle between two planes',
      'Distance of a point from plane',
      'Angle between line and plane',
      'Coplanarity of two lines'
    ],
    priority: 4
  },

  // Unit 5: Linear Programming
  {
    class: '12',
    subject: 'Mathematics',
    chapter: 'Linear Programming',
    topics: [
      'Linear programming problem',
      'Objective function',
      'Constraints',
      'Optimization',
      'Graphical method',
      'Feasible region',
      'Corner point method',
      'Iso-profit line',
      'Formulation of LPP',
      'Mathematical formulation',
      'Graphical solution'
    ],
    priority: 3
  },

  // Unit 6: Probability
  {
    class: '12',
    subject: 'Mathematics',
    chapter: 'Probability',
    topics: [
      'Conditional probability',
      'Multiplication theorem',
      'Independent events',
      'Total probability',
      'Bayes theorem',
      'Random variable',
      'Probability distribution',
      'Mean of random variable',
      'Variance of random variable',
      'Binomial distribution',
      'Mean and variance of binomial distribution'
    ],
    priority: 5
  }
]

/**
 * Get all unique subjects from the syllabus
 */
export function getSubjects(): string[] {
  return Array.from(new Set(class12Syllabus.map(entry => entry.subject)))
}

/**
 * Get chapters for a specific subject
 */
export function getChaptersBySubject(subject: string): string[] {
  return class12Syllabus
    .filter(entry => entry.subject === subject)
    .map(entry => entry.chapter)
}

/**
 * Get syllabus entries by subject
 */
export function getSyllabusBySubject(subject: string): SyllabusEntry[] {
  return class12Syllabus.filter(entry => entry.subject === subject)
}

/**
 * Get a specific chapter entry
 */
export function getChapterEntry(subject: string, chapter: string): SyllabusEntry | undefined {
  return class12Syllabus.find(
    entry => entry.subject === subject && entry.chapter === chapter
  )
}
