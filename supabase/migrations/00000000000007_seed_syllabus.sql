-- Migration: Seed Syllabus Data
-- Description: Insert Class 12 CBSE Syllabus for Physics, Chemistry, Mathematics, and Biology
-- Created: 2026-01-31
-- Source: syllabus.md (CBSE Class 12 Syllabus 2024-2025)

-- Clear existing Class 12 syllabus
DELETE FROM syllabus WHERE class = '12';

-- ============================================
-- PHYSICS
-- ============================================

-- Unit I: Electrostatics
INSERT INTO syllabus (class, subject, chapter, topics, priority, is_verified) VALUES
('12', 'Physics', 'Electric Charges and Fields', '["Electric Charges", "Conservation of charge", "Coulomb''s law-force between two point charges", "Forces between multiple charges", "Superposition principle and continuous charge distribution", "Electric field", "Electric field due to a point charge", "Electric field lines", "Electric dipole", "Electric field due to a dipole", "Torque on a dipole in uniform electric field", "Electric flux", "Gauss''s theorem", "Field due to infinitely long straight wire", "Uniformly charged infinite plane sheet", "Uniformly charged thin spherical shell"]'::jsonb, 5, true);

INSERT INTO syllabus (class, subject, chapter, topics, priority, is_verified) VALUES
('12', 'Physics', 'Electrostatic Potential and Capacitance', '["Electric potential", "Potential difference", "Electric potential due to a point charge", "Electric potential due to a dipole", "Electric potential due to system of charges", "Equipotential surfaces", "Electrical potential energy of a system", "Conductors and insulators", "Free charges and bound charges inside a conductor", "Dielectrics and electric polarisation", "Capacitors and capacitance", "Combination of capacitors in series and parallel", "Capacitance of parallel plate capacitor", "Energy stored in a capacitor"]'::jsonb, 5, true);

-- Unit II: Current Electricity
INSERT INTO syllabus (class, subject, chapter, topics, priority, is_verified) VALUES
('12', 'Physics', 'Current Electricity', '["Electric current", "Flow of electric charges in metallic conductor", "Drift velocity and mobility", "Relation with electric current", "Ohm''s law", "Electrical resistance", "V-I characteristics", "Electrical energy and power", "Electrical resistivity and conductivity", "Carbon resistors and colour code", "Series and parallel combinations of resistors", "Temperature dependence of resistance", "Internal resistance of a cell", "Potential difference and emf of a cell", "Combination of cells", "Kirchhoff''s laws", "Wheatstone bridge", "Metre bridge", "Potentiometer principle and applications"]'::jsonb, 5, true);

-- Unit III: Magnetic Effects of Current and Magnetism
INSERT INTO syllabus (class, subject, chapter, topics, priority, is_verified) VALUES
('12', 'Physics', 'Moving Charges and Magnetism', '["Concept of magnetic field", "Oersted''s experiment", "Biot-Savart law", "Application to current carrying circular loop", "Ampere''s law", "Applications to straight wire and solenoids", "Force on moving charge in uniform magnetic field", "Force on moving charge in uniform electric field", "Cyclotron", "Force on current-carrying conductor", "Force between parallel current-carrying conductors", "Definition of ampere", "Torque on current loop in uniform magnetic field", "Moving coil galvanometer", "Current sensitivity", "Conversion to ammeter and voltmeter"]'::jsonb, 5, true);

INSERT INTO syllabus (class, subject, chapter, topics, priority, is_verified) VALUES
('12', 'Physics', 'Magnetism and Matter', '["Current loop as magnetic dipole", "Magnetic dipole moment", "Magnetic dipole moment of revolving electron", "Magnetic field intensity due to magnetic dipole", "Torque on magnetic dipole in uniform field", "Bar magnet as equivalent solenoid", "Magnetic field lines", "Earth''s magnetic field and magnetic elements", "Para-dia-ferromagnetic substances", "Electromagnets and factors affecting strength", "Permanent magnets"]'::jsonb, 4, true);

-- Unit IV: Electromagnetic Induction and Alternating Currents
INSERT INTO syllabus (class, subject, chapter, topics, priority, is_verified) VALUES
('12', 'Physics', 'Electromagnetic Induction', '["Electromagnetic induction", "Faraday''s laws", "Induced EMF and current", "Lenz''s Law", "Eddy currents", "Self induction", "Mutual induction"]'::jsonb, 4, true);

INSERT INTO syllabus (class, subject, chapter, topics, priority, is_verified) VALUES
('12', 'Physics', 'Alternating Current', '["Alternating currents", "Peak and rms value", "Reactance and impedance", "LC oscillations", "LCR series circuit", "Resonance", "Power in AC circuits", "Wattless current", "AC generator", "Transformer"]'::jsonb, 4, true);

-- Unit V: Electromagnetic Waves
INSERT INTO syllabus (class, subject, chapter, topics, priority, is_verified) VALUES
('12', 'Physics', 'Electromagnetic Waves', '["Displacement current", "Electromagnetic waves characteristics", "Transverse nature of EM waves", "Electromagnetic spectrum", "Radio waves", "Microwaves", "Infrared", "Visible light", "Ultraviolet", "X-rays", "Gamma rays", "Uses of EM waves"]'::jsonb, 2, true);

-- Unit VI: Optics
INSERT INTO syllabus (class, subject, chapter, topics, priority, is_verified) VALUES
('12', 'Physics', 'Ray Optics and Optical Instruments', '["Reflection of light", "Spherical mirrors", "Mirror formula", "Refraction of light", "Total internal reflection", "Optical fibres", "Refraction at spherical surfaces", "Lenses", "Thin lens formula", "Lensmaker''s formula", "Magnification", "Power of lens", "Combination of thin lenses", "Refraction and dispersion through prism", "Scattering of light", "Human eye and image formation", "Correction of eye defects", "Microscopes", "Astronomical telescopes", "Magnifying powers"]'::jsonb, 5, true);

INSERT INTO syllabus (class, subject, chapter, topics, priority, is_verified) VALUES
('12', 'Physics', 'Wave Optics', '["Wavefront", "Huygens'' principle", "Reflection using wavefronts", "Refraction using wavefronts", "Interference", "Young''s double slit experiment", "Fringe width", "Coherent sources", "Diffraction due to single slit", "Width of central maximum", "Resolving power", "Polarisation", "Plane polarised light", "Brewster''s law", "Uses of plane polarised light", "Polaroids"]'::jsonb, 4, true);

-- Unit VII: Dual Nature of Radiation and Matter
INSERT INTO syllabus (class, subject, chapter, topics, priority, is_verified) VALUES
('12', 'Physics', 'Dual Nature of Radiation and Matter', '["Dual nature of radiation", "Photoelectric effect", "Hertz and Lenard''s observations", "Einstein''s photoelectric equation", "Particle nature of light", "Matter waves", "Wave nature of particles", "de Broglie relation", "Davisson-Germer experiment"]'::jsonb, 4, true);

-- Unit VIII: Atoms and Nuclei
INSERT INTO syllabus (class, subject, chapter, topics, priority, is_verified) VALUES
('12', 'Physics', 'Atoms', '["Alpha-particle scattering experiment", "Rutherford''s model of atom", "Bohr model", "Energy levels", "Hydrogen spectrum"]'::jsonb, 4, true);

INSERT INTO syllabus (class, subject, chapter, topics, priority, is_verified) VALUES
('12', 'Physics', 'Nuclei', '["Composition and size of nucleus", "Atomic masses", "Isotopes", "Isobars", "Isotones", "Radioactivity", "Alpha beta and gamma particles", "Radioactive decay law", "Mass-energy relation", "Mass defect", "Binding energy per nucleon", "Nuclear fission", "Nuclear fusion"]'::jsonb, 4, true);

-- Unit IX: Electronic Devices
INSERT INTO syllabus (class, subject, chapter, topics, priority, is_verified) VALUES
('12', 'Physics', 'Semiconductor Electronics', '["Energy bands in solids", "Conductors insulators and semiconductors", "Semiconductor diode", "I-V characteristics", "Diode as rectifier", "LED characteristics", "Photodiode characteristics", "Solar cell characteristics", "Zener diode", "Zener diode as voltage regulator", "Junction transistor", "Transistor action", "Transistor as amplifier", "Transistor as oscillator", "Logic gates", "Transistor as switch"]'::jsonb, 4, true);

-- ============================================
-- CHEMISTRY
-- ============================================

-- Unit I: Solutions
INSERT INTO syllabus (class, subject, chapter, topics, priority, is_verified) VALUES
('12', 'Chemistry', 'Solutions', '["Types of solutions", "Expression of concentration", "Solubility of gases in liquids", "Solid solutions", "Colligative properties", "Relative lowering of vapour pressure", "Raoult''s law", "Elevation of boiling point", "Depression of freezing point", "Osmotic pressure", "Determination of molecular masses", "Abnormal molecular mass"]'::jsonb, 5, true);

-- Unit II: Electrochemistry
INSERT INTO syllabus (class, subject, chapter, topics, priority, is_verified) VALUES
('12', 'Chemistry', 'Electrochemistry', '["Redox reactions", "Conductance in electrolytic solutions", "Specific and molar conductivity", "Variations of conductivity with concentration", "Kohlrausch''s Law", "Electrolysis", "Laws of electrolysis", "Dry cell", "Electrolytic cells", "Galvanic cells", "Lead accumulator", "EMF of a cell", "Standard electrode potential", "Nernst equation", "Relation between Gibbs energy and EMF", "Fuel cells", "Corrosion"]'::jsonb, 5, true);

-- Unit III: Chemical Kinetics
INSERT INTO syllabus (class, subject, chapter, topics, priority, is_verified) VALUES
('12', 'Chemistry', 'Chemical Kinetics', '["Rate of reaction", "Average and instantaneous rate", "Factors affecting rates of reaction", "Order and molecularity", "Rate law and specific rate constant", "Integrated rate equations", "Half-life", "Collision theory", "Activation energy", "Arrhenius equation"]'::jsonb, 5, true);

-- Unit V: d and f-Block Elements
INSERT INTO syllabus (class, subject, chapter, topics, priority, is_verified) VALUES
('12', 'Chemistry', 'd and f-Block Elements', '["General introduction", "Electronic configuration", "Occurrence of transition metals", "Characteristics of transition metals", "Metallic character", "Ionization enthalpy", "Oxidation states", "Ionic radii", "Colour", "Catalytic property", "Magnetic properties", "Interstitial compounds", "Alloy formation", "Potassium dichromate", "Potassium permanganate", "Lanthanoids", "Lanthanoid contraction", "Actinoids"]'::jsonb, 4, true);

-- Unit VI: Coordination Compounds
INSERT INTO syllabus (class, subject, chapter, topics, priority, is_verified) VALUES
('12', 'Chemistry', 'Coordination Compounds', '["Introduction", "Ligands", "Coordination number", "Colour", "Magnetic properties", "Shapes", "IUPAC nomenclature", "Werner''s theory", "VBT", "CFT", "Isomerism", "Importance in qualitative analysis", "Extraction of metals", "Biological systems"]'::jsonb, 4, true);

-- Unit VII: Haloalkanes and Haloarenes
INSERT INTO syllabus (class, subject, chapter, topics, priority, is_verified) VALUES
('12', 'Chemistry', 'Haloalkanes and Haloarenes', '["Nomenclature", "Nature of C-X bond", "Physical properties", "Chemical properties", "Mechanism of substitution reactions", "Optical rotation", "Substitution reactions in haloarenes", "Uses and environmental effects", "Dichloromethane", "Trichloromethane", "Tetrachloromethane", "Iodoform", "Freons", "DDT"]'::jsonb, 4, true);

-- Unit VIII: Alcohols, Phenols and Ethers
INSERT INTO syllabus (class, subject, chapter, topics, priority, is_verified) VALUES
('12', 'Chemistry', 'Alcohols, Phenols and Ethers', '["Nomenclature", "Methods of preparation", "Physical properties", "Chemical properties of alcohols", "Identification of alcohols", "Mechanism of dehydration", "Chemical properties of phenols", "Acidic nature of phenol", "Electrophilic substitution", "Kolbe reaction", "Reimer-Tiemann reaction", "Chemical properties of ethers", "Williamson synthesis", "Uses"]'::jsonb, 4, true);

-- Unit IX: Aldehydes, Ketones and Carboxylic Acids
INSERT INTO syllabus (class, subject, chapter, topics, priority, is_verified) VALUES
('12', 'Chemistry', 'Aldehydes, Ketones and Carboxylic Acids', '["Nomenclature", "Nature of carbonyl group", "Methods of preparation", "Physical properties", "Chemical properties", "Nucleophilic addition", "Reactivity of alpha hydrogen", "Aldol condensation", "Cannizzaro reaction", "Acidity of carboxylic acids", "Formation of acid derivatives", "Uses"]'::jsonb, 5, true);

-- Unit X: Amines
INSERT INTO syllabus (class, subject, chapter, topics, priority, is_verified) VALUES
('12', 'Chemistry', 'Amines', '["Nomenclature", "Classification", "Structure", "Methods of preparation", "Physical properties", "Chemical properties", "Basicity of amines", "Identification of amines", "Diazonium salts", "Preparation and reactions"]'::jsonb, 4, true);

-- Unit XI: Biomolecules
INSERT INTO syllabus (class, subject, chapter, topics, priority, is_verified) VALUES
('12', 'Chemistry', 'Biomolecules', '["Carbohydrates", "Classification", "Monosaccharides", "Glucose and fructose", "Oligosaccharides", "Polysaccharides", "Proteins", "Amino acids", "Peptide bond", "Structure of proteins", "Denaturation", "Enzymes", "Vitamins", "Nucleic acids", "DNA and RNA"]'::jsonb, 4, true);

-- ============================================
-- MATHEMATICS
-- ============================================

-- Unit I: Relations and Functions
INSERT INTO syllabus (class, subject, chapter, topics, priority, is_verified) VALUES
('12', 'Mathematics', 'Relations and Functions', '["Types of relations", "Reflexive relation", "Symmetric relation", "Transitive relation", "Equivalence relation", "One to one function", "Onto function", "Composite functions", "Inverse of a function"]'::jsonb, 4, true);

INSERT INTO syllabus (class, subject, chapter, topics, priority, is_verified) VALUES
('12', 'Mathematics', 'Inverse Trigonometric Functions', '["Domain and range", "Principal value branch", "Graphs of inverse trigonometric functions", "Elementary properties"]'::jsonb, 4, true);

-- Unit II: Algebra
INSERT INTO syllabus (class, subject, chapter, topics, priority, is_verified) VALUES
('12', 'Mathematics', 'Matrices', '["Types of matrices", "Row matrix", "Column matrix", "Square matrix", "Diagonal matrix", "Scalar matrix", "Identity matrix", "Zero matrix", "Symmetric matrix", "Skew-symmetric matrix", "Operations on matrices", "Addition", "Multiplication", "Transpose", "Inverse of matrix", "Adjoint", "Elementary operations"]'::jsonb, 5, true);

INSERT INTO syllabus (class, subject, chapter, topics, priority, is_verified) VALUES
('12', 'Mathematics', 'Determinants', '["Determinant of square matrix", "Properties of determinants", "Minors and cofactors", "Adjoint and inverse", "Applications", "Area of triangle", "Solution of linear equations", "Consistency", "Cramers rule"]'::jsonb, 5, true);

-- Unit III: Calculus
INSERT INTO syllabus (class, subject, chapter, topics, priority, is_verified) VALUES
('12', 'Mathematics', 'Continuity and Differentiability', '["Continuity of function", "Differentiability", "Derivative of composite functions", "Chain rule", "Derivative of inverse trigonometric functions", "Derivative of implicit functions", "Exponential and logarithmic functions", "Logarithmic differentiation", "Parametric differentiation", "Second order derivatives", "Rolle''s theorem", "Mean value theorem"]'::jsonb, 5, true);

INSERT INTO syllabus (class, subject, chapter, topics, priority, is_verified) VALUES
('12', 'Mathematics', 'Applications of Derivatives', '["Rate of change", "Increasing and decreasing functions", "Tangents and normals", "Approximations", "Maxima and minima", "First derivative test", "Second derivative test", "Optimization problems"]'::jsonb, 5, true);

INSERT INTO syllabus (class, subject, chapter, topics, priority, is_verified) VALUES
('12', 'Mathematics', 'Integrals', '["Indefinite integrals", "Integration as anti-derivative", "Fundamental theorems", "Integration by substitution", "Integration by parts", "Integration by partial fractions", "Definite integrals", "Properties of definite integrals"]'::jsonb, 5, true);

INSERT INTO syllabus (class, subject, chapter, topics, priority, is_verified) VALUES
('12', 'Mathematics', 'Applications of Integrals', '["Area under curves", "Area between curves", "Area bounded by curve and line"]'::jsonb, 4, true);

INSERT INTO syllabus (class, subject, chapter, topics, priority, is_verified) VALUES
('12', 'Mathematics', 'Differential Equations', '["Order and degree", "General and particular solutions", "Formation of differential equations", "Variable separable method", "Homogeneous differential equations", "Linear differential equations"]'::jsonb, 4, true);

-- Unit IV: Vectors and 3D Geometry
INSERT INTO syllabus (class, subject, chapter, topics, priority, is_verified) VALUES
('12', 'Mathematics', 'Vectors', '["Vectors and scalars", "Position vector", "Direction cosines", "Direction ratios", "Types of vectors", "Addition of vectors", "Multiplication by scalar", "Section formula", "Scalar product", "Dot product", "Vector product", "Cross product", "Scalar triple product"]'::jsonb, 5, true);

INSERT INTO syllabus (class, subject, chapter, topics, priority, is_verified) VALUES
('12', 'Mathematics', 'Three Dimensional Geometry', '["Direction cosines and ratios", "Equation of line in space", "Cartesian form", "Vector form", "Angle between lines", "Shortest distance between lines", "Equation of plane", "Angle between planes", "Distance of point from plane"]'::jsonb, 4, true);

-- Unit V: Linear Programming
INSERT INTO syllabus (class, subject, chapter, topics, priority, is_verified) VALUES
('12', 'Mathematics', 'Linear Programming', '["Linear programming problem", "Objective function", "Constraints", "Optimization", "Graphical method", "Feasible region", "Corner point method"]'::jsonb, 3, true);

-- Unit VI: Probability
INSERT INTO syllabus (class, subject, chapter, topics, priority, is_verified) VALUES
('12', 'Mathematics', 'Probability', '["Conditional probability", "Multiplication theorem", "Independent events", "Total probability", "Bayes theorem", "Random variable", "Probability distribution", "Mean and variance", "Binomial distribution"]'::jsonb, 5, true);

-- ============================================
-- BIOLOGY
-- ============================================

-- Unit VI: Reproduction
INSERT INTO syllabus (class, subject, chapter, topics, priority, is_verified) VALUES
('12', 'Biology', 'Sexual Reproduction in Flowering Plants', '["Flower structure", "Development of male gametophytes", "Development of female gametophytes", "Pollination types", "Pollination agencies", "Outbreeding devices", "Pollen-pistil interaction", "Double fertilization", "Post fertilization events", "Development of endosperm", "Development of embryo", "Apomixis", "Parthenocarpy", "Polyembryony"]'::jsonb, 5, true);

INSERT INTO syllabus (class, subject, chapter, topics, priority, is_verified) VALUES
('12', 'Biology', 'Human Reproduction', '["Male reproductive system", "Female reproductive system", "Microscopic anatomy of testis", "Microscopic anatomy of ovary", "Gametogenesis", "Spermatogenesis", "Oogenesis", "Menstrual cycle", "Fertilisation", "Embryo development", "Implantation", "Pregnancy", "Placenta formation", "Parturition", "Lactation"]'::jsonb, 5, true);

INSERT INTO syllabus (class, subject, chapter, topics, priority, is_verified) VALUES
('12', 'Biology', 'Reproductive Health', '["Need for reproductive health", "Prevention of STDs", "Birth control methods", "Contraception", "Medical termination of pregnancy", "Amniocentesis", "Infertility", "Assisted reproductive technologies", "IVF", "ZIFT", "GIFT"]'::jsonb, 4, true);

-- Unit VII: Genetics and Evolution
INSERT INTO syllabus (class, subject, chapter, topics, priority, is_verified) VALUES
('12', 'Biology', 'Principles of Inheritance and Variation', '["Heredity and variation", "Mendelian inheritance", "Incomplete dominance", "Co-dominance", "Multiple alleles", "Blood groups inheritance", "Pleiotropy", "Polygenic inheritance", "Chromosome theory", "Sex determination", "Linkage and crossing over", "Sex linked inheritance", "Haemophilia", "Colour blindness", "Mendelian disorders", "Chromosomal disorders", "Down''s syndrome", "Turner''s syndrome", "Klinefelter''s syndrome"]'::jsonb, 5, true);

INSERT INTO syllabus (class, subject, chapter, topics, priority, is_verified) VALUES
('12', 'Biology', 'Molecular Basis of Inheritance', '["Search for genetic material", "DNA as genetic material", "Structure of DNA", "Structure of RNA", "DNA packaging", "DNA replication", "Central dogma", "Transcription", "Genetic code", "Translation", "Gene expression", "Lac operon", "Human genome project", "DNA fingerprinting"]'::jsonb, 5, true);

INSERT INTO syllabus (class, subject, chapter, topics, priority, is_verified) VALUES
('12', 'Biology', 'Evolution', '["Origin of life", "Biological evolution", "Evidences for evolution", "Paleontological evidence", "Comparative anatomy", "Embryology", "Molecular evidence", "Darwin''s contribution", "Modern synthetic theory", "Mechanism of evolution", "Variation", "Natural selection", "Gene flow", "Genetic drift", "Hardy-Weinberg principle", "Adaptive radiation", "Human evolution"]'::jsonb, 5, true);

-- Unit VIII: Biology and Human Welfare
INSERT INTO syllabus (class, subject, chapter, topics, priority, is_verified) VALUES
('12', 'Biology', 'Human Health and Diseases', '["Pathogens", "Parasites causing human diseases", "Malaria", "Typhoid", "Pneumonia", "Common cold", "Amoebiasis", "Basic concepts of immunology", "Vaccines", "Cancer", "HIV and AIDS", "Drug and alcohol abuse"]'::jsonb, 4, true);

INSERT INTO syllabus (class, subject, chapter, topics, priority, is_verified) VALUES
('12', 'Biology', 'Microbes in Human Welfare', '["Microbes in household food processing", "Industrial production", "Sewage treatment", "Energy generation", "Biocontrol agents", "Biofertilizers"]'::jsonb, 3, true);

-- Unit IX: Biotechnology and its Applications
INSERT INTO syllabus (class, subject, chapter, topics, priority, is_verified) VALUES
('12', 'Biology', 'Biotechnology - Principles and Processes', '["Genetic engineering", "Recombinant DNA technology"]'::jsonb, 4, true);

INSERT INTO syllabus (class, subject, chapter, topics, priority, is_verified) VALUES
('12', 'Biology', 'Biotechnology and its Applications', '["Application in health", "Human insulin production", "Vaccine production", "Gene therapy", "Genetically modified organisms", "Bt crops", "Transgenic animals", "Biosafety issues", "Biopiracy", "Patents"]'::jsonb, 4, true);

-- Unit X: Ecology and Environment
INSERT INTO syllabus (class, subject, chapter, topics, priority, is_verified) VALUES
('12', 'Biology', 'Organisms and Populations', '["Organisms and environment", "Habitat", "Niche", "Population", "Ecological adaptations", "Population interactions", "Mutualism", "Competition", "Predation", "Parasitism", "Population attributes", "Growth", "Birth rate", "Death rate"]'::jsonb, 3, true);

INSERT INTO syllabus (class, subject, chapter, topics, priority, is_verified) VALUES
('12', 'Biology', 'Ecosystem', '["Ecosystem patterns", "Components", "Productivity", "Decomposition", "Energy flow", "Pyramids", "Nutrient cycling", "Carbon cycling", "Phosphorous cycling", "Ecological succession", "Ecological services"]'::jsonb, 3, true);

INSERT INTO syllabus (class, subject, chapter, topics, priority, is_verified) VALUES
('12', 'Biology', 'Biodiversity and Conservation', '["Concept of biodiversity", "Patterns of biodiversity", "Importance of biodiversity", "Loss of biodiversity", "Biodiversity conservation", "Hotspots", "Endangered organisms", "Extinction", "Red Data Book", "Biosphere reserves", "National parks", "Sanctuaries"]'::jsonb, 3, true);
