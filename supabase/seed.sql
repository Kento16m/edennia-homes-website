-- Local development seed (never run against production).
-- Staff users, catalogs, 24 properties in Asunción with ES/EN content, 40 synthetic leads, synthetic views.
-- People and emails are fictional (example.com). No testimonials: they must come from real clients.
-- Local password for every seed user: edennia-local-2026 (see supabase/README.md).

-- ── Staff users (trigger private.handle_new_user creates the profiles from app_metadata.role) ──
insert into auth.users (
  instance_id, id, aud, role, email, encrypted_password, email_confirmed_at,
  raw_app_meta_data, raw_user_meta_data, created_at, updated_at,
  confirmation_token, email_change, email_change_token_new, recovery_token
)
select
  '00000000-0000-0000-0000-000000000000', u.id, 'authenticated', 'authenticated', u.email,
  extensions.crypt('edennia-local-2026', extensions.gen_salt('bf')), now(),
  jsonb_build_object('provider', 'email', 'providers', jsonb_build_array('email'), 'role', u.role),
  jsonb_build_object('full_name', u.full_name), now(), now(), '', '', '', ''
from (values
  ('00000000-0000-4000-8000-000000000001'::uuid, 'admin@edennia.test',   'admin',  'Admin Edennia'),
  ('00000000-0000-4000-8000-000000000002'::uuid, 'asesor1@edennia.test', 'agent',  'Lucía Martín'),
  ('00000000-0000-4000-8000-000000000003'::uuid, 'asesor2@edennia.test', 'agent',  'Javier Ortega'),
  ('00000000-0000-4000-8000-000000000004'::uuid, 'editor@edennia.test',  'editor', 'Ana Benítez')
) as u(id, email, role, full_name);

insert into auth.identities (id, user_id, provider_id, identity_data, provider, last_sign_in_at, created_at, updated_at)
select gen_random_uuid(), u.id, u.id::text,
       jsonb_build_object('sub', u.id::text, 'email', u.email, 'email_verified', true),
       'email', now(), now(), now()
  from auth.users u
 where u.email like '%@edennia.test';

update public.profiles set phone = '+595 975 500 150', whatsapp = '+595975500150'
 where id in ('00000000-0000-4000-8000-000000000002', '00000000-0000-4000-8000-000000000003');

-- ── Locales ──────────────────────────────────────────────────────────────────
insert into public.locales (code, name, native_name, is_default, is_enabled, is_required, sort_order) values
  ('es', 'Spanish', 'Español', true, true, true, 1),
  ('en', 'English', 'English', false, true, true, 2);

-- ── Zones (real neighbourhood centres) ───────────────────────────────────────
insert into public.zones (id, center, sort_order) values
  ('20000000-0000-4000-8000-000000000001', extensions.st_point(-57.5803, -25.2944, 4326)::extensions.geography, 1),
  ('20000000-0000-4000-8000-000000000002', extensions.st_point(-57.5729, -25.2876, 4326)::extensions.geography, 2),
  ('20000000-0000-4000-8000-000000000003', extensions.st_point(-57.5885, -25.2976, 4326)::extensions.geography, 3),
  ('20000000-0000-4000-8000-000000000004', extensions.st_point(-57.6040, -25.2893, 4326)::extensions.geography, 4),
  ('20000000-0000-4000-8000-000000000005', extensions.st_point(-57.5592, -25.2836, 4326)::extensions.geography, 5),
  ('20000000-0000-4000-8000-000000000006', extensions.st_point(-57.4872, -25.2700, 4326)::extensions.geography, 6);

insert into public.zone_translations (zone_id, locale, name, slug, description) values
  ('20000000-0000-4000-8000-000000000001', 'es', 'Villa Morra', 'villa-morra', 'Barrio residencial y comercial con los mejores restaurantes y shoppings de Asunción.'),
  ('20000000-0000-4000-8000-000000000001', 'en', 'Villa Morra', 'villa-morra', 'Residential and commercial district with Asunción''s best restaurants and shopping centres.'),
  ('20000000-0000-4000-8000-000000000002', 'es', 'Carmelitas', 'carmelitas', 'Calles arboladas, embajadas y casas amplias a minutos del centro financiero.'),
  ('20000000-0000-4000-8000-000000000002', 'en', 'Carmelitas', 'carmelitas', 'Tree-lined streets, embassies and spacious homes minutes from the financial district.'),
  ('20000000-0000-4000-8000-000000000003', 'es', 'Recoleta', 'recoleta', 'Barrio tranquilo y bien conectado, ideal para familias.'),
  ('20000000-0000-4000-8000-000000000003', 'en', 'Recoleta', 'recoleta', 'Quiet, well-connected neighbourhood, ideal for families.'),
  ('20000000-0000-4000-8000-000000000004', 'es', 'Las Mercedes', 'las-mercedes', 'Casas clásicas y edificios nuevos cerca del centro histórico.'),
  ('20000000-0000-4000-8000-000000000004', 'en', 'Las Mercedes', 'las-mercedes', 'Classic houses and new buildings close to the historic centre.'),
  ('20000000-0000-4000-8000-000000000005', 'es', 'Mburucuyá', 'mburucuya', 'Zona residencial verde con colegios internacionales cerca.'),
  ('20000000-0000-4000-8000-000000000005', 'en', 'Mburucuyá', 'mburucuya', 'Green residential area close to international schools.'),
  ('20000000-0000-4000-8000-000000000006', 'es', 'Luque', 'luque', 'Ciudad vecina junto al aeropuerto internacional, con más terreno por el mismo precio.'),
  ('20000000-0000-4000-8000-000000000006', 'en', 'Luque', 'luque', 'Neighbouring city by the international airport, with more land for the same price.');

-- ── Amenities ────────────────────────────────────────────────────────────────
insert into public.amenities (key, icon, sort_order) values
  ('pool', 'waves', 1), ('quincho', 'flame', 2), ('security_24h', 'shield-check', 3), ('pets_allowed', 'paw-print', 4),
  ('furnished', 'sofa', 5), ('air_conditioning', 'air-vent', 6), ('gym', 'dumbbell', 7), ('garden', 'trees', 8),
  ('covered_parking', 'car', 9), ('elevator', 'arrow-up-down', 10), ('generator', 'zap', 11), ('playground', 'baby', 12),
  ('terrace', 'sun', 13), ('laundry', 'washing-machine', 14), ('storage_room', 'archive', 15);

insert into public.amenity_translations (amenity_id, locale, name)
select a.id, t.locale, t.name
  from (values
    ('pool', 'es', 'Piscina'), ('pool', 'en', 'Swimming pool'),
    ('quincho', 'es', 'Quincho'), ('quincho', 'en', 'Barbecue area (quincho)'),
    ('security_24h', 'es', 'Seguridad 24 h'), ('security_24h', 'en', '24 h security'),
    ('pets_allowed', 'es', 'Admite mascotas'), ('pets_allowed', 'en', 'Pets allowed'),
    ('furnished', 'es', 'Amoblado'), ('furnished', 'en', 'Furnished'),
    ('air_conditioning', 'es', 'Aire acondicionado'), ('air_conditioning', 'en', 'Air conditioning'),
    ('gym', 'es', 'Gimnasio'), ('gym', 'en', 'Gym'),
    ('garden', 'es', 'Jardín'), ('garden', 'en', 'Garden'),
    ('covered_parking', 'es', 'Cochera techada'), ('covered_parking', 'en', 'Covered parking'),
    ('elevator', 'es', 'Ascensor'), ('elevator', 'en', 'Lift'),
    ('generator', 'es', 'Generador'), ('generator', 'en', 'Backup generator'),
    ('playground', 'es', 'Área de juegos'), ('playground', 'en', 'Playground'),
    ('terrace', 'es', 'Terraza'), ('terrace', 'en', 'Terrace'),
    ('laundry', 'es', 'Lavadero'), ('laundry', 'en', 'Laundry room'),
    ('storage_room', 'es', 'Depósito'), ('storage_room', 'en', 'Storage room')
  ) as t(key, locale, name)
  join public.amenities a on a.key = t.key;

-- ── Properties (inserted as draft; published below once translations exist) ──
insert into public.properties (
  id, type, price, bedrooms, bathrooms, area_m2, lot_m2, parking, year_built, availability,
  is_featured, residency_eligible, agent_id, hide_exact_address, construction_progress, delivery_date,
  sold_at, zone_id, location, address_line, created_by
)
select
  ('10000000-0000-4000-8000-' || lpad(v.n::text, 12, '0'))::uuid,
  v.type::public.property_type, v.price, v.bd, v.ba, v.m2, v.lot, v.park, v.year,
  v.avail::public.availability_status, v.feat, v.res,
  ('00000000-0000-4000-8000-00000000000' || (v.agent + 1))::uuid,
  v.hide, v.progress, v.delivery, v.sold_at,
  ('20000000-0000-4000-8000-00000000000' || v.zone)::uuid,
  extensions.st_point(v.lng, v.lat, 4326)::extensions.geography,
  v.address,
  '00000000-0000-4000-8000-000000000001'::uuid
from (values
  -- n, type, zone, price, bd, ba, m2, lot, park, year, avail, feat, res, agent, hide, progress, delivery, sold_at, lng, lat, address
  ( 1, 'house',       1, 420000, 4, 4, 380, 600,  3, 2018, 'available', true,  true,  1, true,  null::smallint, null::date, null::timestamptz, -57.5791, -25.2952, 'Calle Dr. Morra 1450'),
  ( 2, 'house',       1, 365000, 3, 3, 290, 450,  2, 2015, 'available', false, true,  2, true,  null, null, null, -57.5822, -25.2931, 'Calle Senador Long 820'),
  ( 3, 'house',       2, 590000, 5, 5, 520, 900,  4, 2021, 'available', true,  true,  1, true,  null, null, null, -57.5711, -25.2869, 'Calle Malutín 1210'),
  ( 4, 'house',       2, 480000, 4, 4, 410, 700,  3, 2019, 'reserved',  false, true,  2, true,  null, null, null, -57.5745, -25.2891, 'Calle Lillo 1830'),
  ( 5, 'house',       3, 245000, 3, 2, 210, 360,  2, 2008, 'available', false, false, 1, true,  null, null, null, -57.5872, -25.2989, 'Calle Cruz del Chaco 2140'),
  ( 6, 'house',       4, 310000, 4, 3, 300, 520,  2, 1998, 'available', false, false, 2, true,  null, null, null, -57.6052, -25.2880, 'Calle Perú 1560'),
  ( 7, 'house',       5, 285000, 3, 3, 260, 480,  2, 2012, 'sold',      false, false, 1, true,  null, null, now() - interval '20 days', -57.5604, -25.2849, 'Calle Concordia 3310'),
  ( 8, 'house',       6, 175000, 3, 2, 190, 600,  2, 2016, 'available', false, true,  2, true,  null, null, null, -57.4891, -25.2688, 'Calle Gral. Aquino 455'),
  ( 9, 'house',       6, 198000, 4, 3, 240, 800,  3, 2020, 'available', false, false, 1, true,  null, null, null, -57.4850, -25.2723, 'Calle Sportivo Luqueño 1120'),
  (10, 'house',       5, 335000, 4, 3, 310, 550,  2, 2014, 'available', false, true,  2, true,  null, null, null, -57.5578, -25.2822, 'Calle Itapúa 2780'),
  (11, 'apartment',   1, 189000, 2, 2, 105, null, 1, 2022, 'available', true,  true,  1, true,  null, null, null, -57.5788, -25.2939, 'Av. Aviadores del Chaco 2050'),
  (12, 'apartment',   1, 135000, 1, 1,  68, null, 1, 2023, 'available', false, false, 2, true,  null, null, null, -57.5812, -25.2958, 'Calle Charles de Gaulle 980'),
  (13, 'apartment',   2, 265000, 3, 3, 160, null, 2, 2021, 'available', false, true,  1, true,  null, null, null, -57.5736, -25.2860, 'Av. Mcal. López 4210'),
  (14, 'apartment',   3, 112000, 2, 1,  78, null, 1, 2017, 'available', false, false, 2, true,  null, null, null, -57.5897, -25.2968, 'Calle Juan de Salazar 1620'),
  (15, 'apartment',   4,  98000, 1, 1,  55, null, 1, 2019, 'sold',      false, false, 1, true,  null, null, now() - interval '50 days', -57.6031, -25.2904, 'Calle Brasil 1340'),
  (16, 'apartment',   5, 154000, 2, 2,  98, null, 1, 2020, 'available', false, false, 2, true,  null, null, null, -57.5615, -25.2829, 'Calle Santísima Trinidad 2600'),
  (17, 'apartment',   3, 225000, 3, 2, 140, null, 2, 2016, 'reserved',  false, true,  1, true,  null, null, null, -57.5869, -25.2961, 'Av. España 2950'),
  (18, 'apartment',   2, 320000, 3, 3, 185, null, 2, 2024, 'available', false, true,  2, true,  null, null, null, -57.5720, -25.2883, 'Calle Austria 1150'),
  (19, 'condominium', 1, 118000, 1, 1,  62, null, 1, 2027, 'available', true,  true,  1, false, 45::smallint, '2027-12-01'::date, null, -57.5818, -25.2925, 'Av. Santa Teresa 1800'),
  (20, 'condominium', 6, 128000, 2, 2,  70, null, 1, 2028, 'available', false, true,  2, false, 20, '2028-06-01', null, -57.4905, -25.2715, 'Ruta Luque-San Bernardino km 2'),
  (21, 'condominium', 2, 245000, 3, 2, 150, null, 2, 2020, 'available', false, false, 1, true,  null, null, null, -57.5752, -25.2864, 'Calle Bulnes 1690'),
  (22, 'condominium', 4, 168000, 2, 2, 110, null, 1, 2018, 'available', false, false, 2, true,  null, null, null, -57.6019, -25.2879, 'Calle Tacuary 1420'),
  (23, 'condominium', 5, 199000, 3, 3, 175, 220,  2, 2022, 'available', false, true,  1, true,  null, null, null, -57.5571, -25.2851, 'Calle Denis Roa 3050'),
  (24, 'condominium', 3, 142000, 2, 2,  95, null, 1, 2021, 'available', false, false, 2, true,  null, null, null, -57.5903, -25.2991, 'Calle Tte. Vera 1980')
) as v(n, type, zone, price, bd, ba, m2, lot, park, year, avail, feat, res, agent, hide, progress, delivery, sold_at, lng, lat, address);

insert into public.property_translations (property_id, locale, title, slug, short_description, description)
select ('10000000-0000-4000-8000-' || lpad(t.n::text, 12, '0'))::uuid, t.locale, t.title, t.slug, t.short, t.descr
from (values
  ( 1, 'es', 'Casa con piscina y jardín en Villa Morra', 'casa-piscina-jardin-villa-morra', 'Cuatro dormitorios en suite, quincho y jardín maduro a pasos de Shopping Villa Morra.', 'Casa de 2018 en una calle tranquila de Villa Morra. Planta baja abierta al jardín con piscina y quincho, cuatro dormitorios en suite en planta alta y cochera para tres coches. Ideal para una familia que quiere vivir cerca de restaurantes, colegios y oficinas.'),
  ( 1, 'en', 'House with pool and garden in Villa Morra', 'house-pool-garden-villa-morra', 'Four en-suite bedrooms, barbecue area and a mature garden steps from Shopping Villa Morra.', 'A 2018 house on a quiet street in Villa Morra. The ground floor opens onto a garden with a pool and barbecue area, with four en-suite bedrooms upstairs and parking for three cars. Ideal for a family that wants restaurants, schools and offices nearby.'),
  ( 2, 'es', 'Casa luminosa de tres dormitorios en Villa Morra', 'casa-luminosa-tres-dormitorios-villa-morra', 'Tres dormitorios, quincho y generador en una de las zonas más demandadas.', 'Casa bien conservada con grandes ventanales, living comedor en doble altura, quincho cubierto y generador. Barrio con vida, comercios a pie y acceso rápido a la Avenida Mariscal López.'),
  ( 2, 'en', 'Bright three-bedroom house in Villa Morra', 'bright-three-bedroom-house-villa-morra', 'Three bedrooms, barbecue area and backup generator in one of the most sought-after areas.', 'Well-kept house with large windows, a double-height living and dining room, covered barbecue area and backup generator. Lively neighbourhood with shops within walking distance and quick access to Mariscal López Avenue.'),
  ( 3, 'es', 'Residencia de cinco dormitorios en Carmelitas', 'residencia-cinco-dormitorios-carmelitas', 'Arquitectura contemporánea, piscina, terraza y 900 m² de terreno.', 'Residencia de 2021 con acabados de primer nivel, cinco dormitorios en suite, terraza con vistas, piscina y quincho. Calle arbolada con seguridad privada, a minutos del eje corporativo de Asunción.'),
  ( 3, 'en', 'Five-bedroom residence in Carmelitas', 'five-bedroom-residence-carmelitas', 'Contemporary architecture, pool, terrace and a 900 m² plot.', 'A 2021 residence with top-tier finishes, five en-suite bedrooms, a terrace with views, pool and barbecue area. Tree-lined street with private security, minutes from Asunción''s business district.'),
  ( 4, 'es', 'Casa familiar con piscina en Carmelitas', 'casa-familiar-piscina-carmelitas', 'Cuatro dormitorios, piscina y jardín en un entorno de embajadas.', 'Casa de 2019 pensada para la vida en familia: cocina integrada al comedor diario, piscina, jardín y quincho. Zona residencial de embajadas, muy segura y tranquila.'),
  ( 4, 'en', 'Family house with pool in Carmelitas', 'family-house-pool-carmelitas', 'Four bedrooms, pool and garden in an embassy neighbourhood.', 'A 2019 house designed for family life: kitchen open to the dining area, pool, garden and barbecue area. Residential embassy district, very safe and quiet.'),
  ( 5, 'es', 'Casa con jardín en Recoleta', 'casa-jardin-recoleta', 'Tres dormitorios, quincho y patio para mascotas en barrio tranquilo.', 'Casa de una planta con tres dormitorios, quincho, lavadero independiente y jardín. Buena opción para empezar a vivir en Asunción con un presupuesto contenido.'),
  ( 5, 'en', 'House with garden in Recoleta', 'house-garden-recoleta', 'Three bedrooms, barbecue area and a pet-friendly garden in a quiet neighbourhood.', 'Single-storey house with three bedrooms, barbecue area, separate laundry room and garden. A good option to start living in Asunción on a moderate budget.'),
  ( 6, 'es', 'Casa clásica en Las Mercedes', 'casa-clasica-las-mercedes', 'Cuatro dormitorios, techos altos y gran terreno cerca del centro.', 'Casa de estilo clásico con techos altos, galería, quincho y depósito. Excelente ubicación entre el centro histórico y Villa Morra.'),
  ( 6, 'en', 'Classic house in Las Mercedes', 'classic-house-las-mercedes', 'Four bedrooms, high ceilings and a large plot near the centre.', 'Classic-style house with high ceilings, a veranda, barbecue area and storage room. Excellent location between the historic centre and Villa Morra.'),
  ( 7, 'es', 'Casa con piscina en Mburucuyá', 'casa-piscina-mburucuya', 'Tres dormitorios, piscina y jardín cerca de colegios internacionales.', 'Casa de 2012 con piscina, quincho y jardín amplio, en una de las zonas más verdes de Asunción y a pocos minutos de colegios internacionales.'),
  ( 7, 'en', 'House with pool in Mburucuyá', 'house-pool-mburucuya', 'Three bedrooms, pool and garden near international schools.', 'A 2012 house with pool, barbecue area and a large garden in one of Asunción''s greenest areas, a few minutes from international schools.'),
  ( 8, 'es', 'Casa con piscina en Luque, junto al aeropuerto', 'casa-piscina-luque-aeropuerto', 'Tres dormitorios y 600 m² de terreno a diez minutos del aeropuerto.', 'Casa de 2016 con piscina, quincho y jardín grande. Más terreno por el mismo precio que en Asunción y a diez minutos del aeropuerto internacional: ideal para quien viaja a menudo a Europa.'),
  ( 8, 'en', 'House with pool in Luque, by the airport', 'house-pool-luque-airport', 'Three bedrooms and a 600 m² plot ten minutes from the airport.', 'A 2016 house with pool, barbecue area and a large garden. More land for the money than in Asunción, ten minutes from the international airport: ideal if you travel to Europe often.'),
  ( 9, 'es', 'Casa de cuatro dormitorios en Luque', 'casa-cuatro-dormitorios-luque', 'Construcción reciente, piscina, generador y 800 m² de terreno.', 'Casa de 2020 con piscina, quincho, generador y cochera para tres coches. Barrio residencial consolidado en Luque.'),
  ( 9, 'en', 'Four-bedroom house in Luque', 'four-bedroom-house-luque', 'Recent build, pool, backup generator and an 800 m² plot.', 'A 2020 house with pool, barbecue area, backup generator and parking for three cars. Established residential area in Luque.'),
  (10, 'es', 'Casa de cuatro dormitorios en Mburucuyá', 'casa-cuatro-dormitorios-mburucuya', 'Cuatro dormitorios y jardín en zona residencial verde.', 'Casa de 2014 con cuatro dormitorios, jardín y quincho, en una calle tranquila de Mburucuyá.'),
  (10, 'en', 'Four-bedroom house in Mburucuyá', 'four-bedroom-house-mburucuya', 'Four bedrooms and a garden in a green residential area.', 'A 2014 house with four bedrooms, garden and barbecue area on a quiet street in Mburucuyá.'),
  (11, 'es', 'Apartamento con amenities en Villa Morra', 'apartamento-amenities-villa-morra', 'Dos dormitorios en edificio con piscina, gimnasio y seguridad 24 h.', 'Apartamento de 2022 en edificio con piscina en la azotea, gimnasio y seguridad 24 h. Terraza propia, aire acondicionado en todos los ambientes y una ubicación inmejorable para vivir sin coche.'),
  (11, 'en', 'Apartment with amenities in Villa Morra', 'apartment-amenities-villa-morra', 'Two bedrooms in a building with pool, gym and 24 h security.', 'A 2022 apartment in a building with a rooftop pool, gym and 24 h security. Private terrace, air conditioning throughout and an unbeatable location for car-free living.'),
  (12, 'es', 'Apartamento amoblado de un dormitorio en Villa Morra', 'apartamento-amoblado-villa-morra', 'Listo para entrar a vivir o alquilar: amoblado y equipado.', 'Apartamento de 2023 completamente amoblado, en edificio con gimnasio y seguridad. Una opción sencilla para invertir o para tus primeros meses en Paraguay.'),
  (12, 'en', 'Furnished one-bedroom apartment in Villa Morra', 'furnished-apartment-villa-morra', 'Ready to move in or let: furnished and equipped.', 'A fully furnished 2023 apartment in a building with gym and security. A simple option to invest or for your first months in Paraguay.'),
  (13, 'es', 'Apartamento de tres dormitorios en Carmelitas', 'apartamento-tres-dormitorios-carmelitas', 'Amplio, con terraza, piscina y gimnasio en el edificio.', 'Apartamento de 160 m² con tres dormitorios en suite, terraza y dos cocheras. Edificio de 2021 con piscina, gimnasio y seguridad 24 h.'),
  (13, 'en', 'Three-bedroom apartment in Carmelitas', 'three-bedroom-apartment-carmelitas', 'Spacious, with terrace, and a pool and gym in the building.', 'A 160 m² apartment with three en-suite bedrooms, terrace and two parking spaces. 2021 building with pool, gym and 24 h security.'),
  (14, 'es', 'Apartamento de dos dormitorios en Recoleta', 'apartamento-dos-dormitorios-recoleta', 'Práctico, luminoso y con lavadero; admite mascotas.', 'Apartamento de 78 m² con dos dormitorios, lavadero y cochera, en edificio con ascensor y seguridad. Barrio tranquilo y bien comunicado.'),
  (14, 'en', 'Two-bedroom apartment in Recoleta', 'two-bedroom-apartment-recoleta', 'Practical and bright, with laundry room; pets allowed.', 'A 78 m² apartment with two bedrooms, laundry room and parking, in a building with lift and security. Quiet, well-connected neighbourhood.'),
  (15, 'es', 'Estudio amoblado en Las Mercedes', 'estudio-amoblado-las-mercedes', 'Un dormitorio amoblado, ideal como primera inversión.', 'Apartamento de un dormitorio, amoblado y con aire acondicionado, en edificio de 2019 cerca del centro.'),
  (15, 'en', 'Furnished studio in Las Mercedes', 'furnished-studio-las-mercedes', 'Furnished one-bedroom, ideal as a first investment.', 'Furnished one-bedroom apartment with air conditioning in a 2019 building near the centre.'),
  (16, 'es', 'Apartamento con piscina en Mburucuyá', 'apartamento-piscina-mburucuya', 'Dos dormitorios en edificio con piscina y área de juegos.', 'Apartamento de 98 m² con dos dormitorios, en edificio familiar con piscina, área de juegos y seguridad.'),
  (16, 'en', 'Apartment with pool in Mburucuyá', 'apartment-pool-mburucuya', 'Two bedrooms in a building with pool and playground.', 'A 98 m² two-bedroom apartment in a family building with pool, playground and security.'),
  (17, 'es', 'Apartamento con terraza en Recoleta', 'apartamento-terraza-recoleta', 'Tres dormitorios y terraza en edificio con piscina.', 'Apartamento de 140 m² con tres dormitorios y terraza, en edificio con piscina y seguridad 24 h.'),
  (17, 'en', 'Apartment with terrace in Recoleta', 'apartment-terrace-recoleta', 'Three bedrooms and a terrace in a building with pool.', 'A 140 m² three-bedroom apartment with terrace in a building with pool and 24 h security.'),
  (18, 'es', 'Apartamento a estrenar en Carmelitas', 'apartamento-a-estrenar-carmelitas', 'Tres dormitorios a estrenar en edificio boutique.', 'Apartamento nuevo de 185 m² en edificio boutique de 2024. Ficha en preparación.'),
  -- 18 has no English on purpose: it cannot be published (tests the publication rule).
  (19, 'es', 'Torre Santa Teresa — preventa en Villa Morra', 'torre-santa-teresa-preventa-villa-morra', 'Unidades de 1 a 4 dormitorios en preventa, entrega en diciembre de 2027.', 'Proyecto residencial en Villa Morra con piscina, gimnasio, terraza y área de juegos. Comprar en pozo permite acceder a mejor precio y elegir unidad; te acompañamos en todo el proceso y en la gestión de tu residencia.'),
  (19, 'en', 'Torre Santa Teresa — off-plan in Villa Morra', 'torre-santa-teresa-off-plan-villa-morra', 'One- to four-bedroom units off-plan, delivery December 2027.', 'Residential project in Villa Morra with pool, gym, terrace and playground. Buying off-plan gives you a better price and your pick of units; we guide you through the whole process and your residency application.'),
  (20, 'es', 'Condominio Jardines de Luque — preventa', 'condominio-jardines-luque-preventa', 'Dúplex de 2 y 3 dormitorios en condominio cerrado, entrega en 2028.', 'Condominio cerrado con piscina, quincho, área de juegos y seguridad, a diez minutos del aeropuerto. Unidades de 2 y 3 dormitorios con jardín propio.'),
  (20, 'en', 'Jardines de Luque gated community — off-plan', 'jardines-de-luque-off-plan', 'Two- and three-bedroom duplexes in a gated community, delivery 2028.', 'Gated community with pool, barbecue area, playground and security, ten minutes from the airport. Two- and three-bedroom units with private gardens.'),
  (21, 'es', 'Casa en condominio en Carmelitas', 'casa-condominio-carmelitas', 'Tres dormitorios en condominio con piscina, gimnasio y seguridad.', 'Casa de 150 m² en condominio cerrado de Carmelitas con piscina, quincho, gimnasio y seguridad 24 h.'),
  (21, 'en', 'House in a gated community in Carmelitas', 'gated-community-house-carmelitas', 'Three bedrooms in a gated community with pool, gym and security.', 'A 150 m² house in a gated community in Carmelitas with pool, barbecue area, gym and 24 h security.'),
  (22, 'es', 'Dúplex en condominio en Las Mercedes', 'duplex-condominio-las-mercedes', 'Dos dormitorios en condominio con piscina y quincho.', 'Dúplex de 110 m² en condominio pequeño con piscina, quincho y seguridad.'),
  (22, 'en', 'Duplex in a gated community in Las Mercedes', 'duplex-gated-community-las-mercedes', 'Two bedrooms in a gated community with pool and barbecue area.', 'A 110 m² duplex in a small gated community with pool, barbecue area and security.'),
  (23, 'es', 'Townhouse en condominio en Mburucuyá', 'townhouse-condominio-mburucuya', 'Tres dormitorios con patio propio en condominio familiar.', 'Townhouse de 2022 con tres dormitorios, patio propio y acceso a piscina, quincho y área de juegos del condominio.'),
  (23, 'en', 'Townhouse in a gated community in Mburucuyá', 'townhouse-gated-community-mburucuya', 'Three bedrooms with a private yard in a family community.', 'A 2022 townhouse with three bedrooms, a private yard and access to the community pool, barbecue area and playground.'),
  (24, 'es', 'Apartamento en condominio en Recoleta', 'apartamento-condominio-recoleta', 'Dos dormitorios en condominio con piscina y ascensor.', 'Apartamento de 95 m² en condominio con piscina, ascensor y seguridad.'),
  (24, 'en', 'Apartment in a gated community in Recoleta', 'apartment-gated-community-recoleta', 'Two bedrooms in a community with pool and lift.', 'A 95 m² apartment in a community with pool, lift and security.')
) as t(n, locale, title, slug, short, descr);

insert into public.property_amenities (property_id, amenity_id)
select ('10000000-0000-4000-8000-' || lpad(x.n::text, 12, '0'))::uuid, a.id
  from (values
    ( 1, array['pool', 'quincho', 'security_24h', 'garden', 'air_conditioning', 'covered_parking']),
    ( 2, array['quincho', 'garden', 'air_conditioning', 'covered_parking', 'generator']),
    ( 3, array['pool', 'quincho', 'security_24h', 'garden', 'air_conditioning', 'generator', 'terrace']),
    ( 4, array['pool', 'quincho', 'garden', 'air_conditioning']),
    ( 5, array['quincho', 'garden', 'pets_allowed', 'laundry']),
    ( 6, array['quincho', 'garden', 'storage_room', 'pets_allowed']),
    ( 7, array['pool', 'quincho', 'garden']),
    ( 8, array['pool', 'quincho', 'garden', 'pets_allowed']),
    ( 9, array['pool', 'quincho', 'garden', 'generator']),
    (10, array['quincho', 'garden']),
    (11, array['elevator', 'gym', 'pool', 'security_24h', 'air_conditioning', 'terrace']),
    (12, array['elevator', 'gym', 'security_24h', 'furnished', 'air_conditioning']),
    (13, array['elevator', 'pool', 'gym', 'security_24h', 'terrace', 'air_conditioning']),
    (14, array['elevator', 'security_24h', 'laundry', 'pets_allowed']),
    (15, array['elevator', 'furnished', 'air_conditioning']),
    (16, array['elevator', 'pool', 'playground', 'security_24h']),
    (17, array['elevator', 'pool', 'security_24h', 'terrace']),
    (18, array['elevator', 'security_24h']),
    (19, array['pool', 'gym', 'security_24h', 'elevator', 'playground', 'terrace', 'generator']),
    (20, array['pool', 'quincho', 'playground', 'security_24h', 'garden']),
    (21, array['pool', 'quincho', 'security_24h', 'gym', 'garden']),
    (22, array['pool', 'security_24h', 'quincho']),
    (23, array['pool', 'quincho', 'security_24h', 'playground', 'garden']),
    (24, array['pool', 'security_24h', 'elevator'])
  ) as x(n, keys)
  cross join lateral unnest(x.keys) as k(key)
  join public.amenities a on a.key = k.key;

insert into public.property_units (property_id, label, bedrooms, bathrooms, area_m2, floor, price, status, sort_order)
values
  ('10000000-0000-4000-8000-000000000019', 'A-101', 1, 1,  62, 1, 118000, 'available', 1),
  ('10000000-0000-4000-8000-000000000019', 'A-102', 2, 2,  88, 1, 165000, 'available', 2),
  ('10000000-0000-4000-8000-000000000019', 'A-201', 2, 2,  88, 2, 169000, 'reserved',  3),
  ('10000000-0000-4000-8000-000000000019', 'A-202', 3, 2, 120, 2, 210000, 'available', 4),
  ('10000000-0000-4000-8000-000000000019', 'B-301', 3, 3, 128, 3, 225000, 'sold',      5),
  ('10000000-0000-4000-8000-000000000019', 'B-PH',  4, 4, 210, 4, 380000, 'available', 6),
  ('10000000-0000-4000-8000-000000000020', 'C-01',  2, 2,  70, 0, 128000, 'available', 1),
  ('10000000-0000-4000-8000-000000000020', 'C-02',  2, 2,  70, 0, 128000, 'reserved',  2),
  ('10000000-0000-4000-8000-000000000020', 'C-03',  3, 2,  95, 0, 162000, 'available', 3),
  ('10000000-0000-4000-8000-000000000020', 'C-04',  3, 3,  98, 0, 168000, 'available', 4);

-- Publish 20 properties (10 and 18 stay draft; 6 and 24 archived). published_at is backdated for analytics.
update public.properties p
   set publication_status = 'published',
       published_at = now() - make_interval(days => (25 - p.reference) * 6)
 where p.reference in (1, 2, 3, 4, 5, 7, 8, 9, 11, 12, 13, 14, 15, 16, 17, 19, 20, 21, 22, 23);

update public.properties set publication_status = 'archived' where reference in (6, 24);

-- ── Leads (synthetic; example.com addresses) ─────────────────────────────────
insert into public.leads (
  full_name, email, phone, country, locale, source, property_id, goal, residency_interest,
  preferred_channel, interest, timezone, message, consent_privacy_at, stage, assigned_to,
  first_response_at, closed_price, closed_currency, closed_at, lost_reason, created_at
)
select
  v.name,
  'lead' || v.n || '@example.com',
  '+' || v.prefix || ' 600 ' || lpad((v.n * 137 % 1000)::text, 3, '0') || ' ' || lpad((v.n * 59 % 1000)::text, 3, '0'),
  v.country,
  v.locale,
  (case v.n % 4 when 0 then 'whatsapp' when 3 then 'contact_form' else 'property_form' end)::public.lead_source,
  case when v.n % 4 in (1, 2) then
    ('10000000-0000-4000-8000-' || lpad(((array[1, 2, 3, 4, 5, 7, 8, 9, 11, 12, 13, 14, 15, 16, 17, 19, 20, 21, 22, 23])[v.n % 20 + 1])::text, 12, '0'))::uuid
  end,
  (array['invest', 'live', 'both'])[v.n % 3 + 1]::public.lead_goal,
  v.n % 3 <> 0,
  (array['whatsapp', 'video_call', 'email', 'phone'])[v.n % 4 + 1]::public.contact_channel,
  (array['video_call', 'info', 'visit', 'financing'])[v.n % 4 + 1]::public.lead_interest,
  v.tz,
  case v.locale
    when 'es' then 'Hola, me interesa conocer más opciones y los pasos para comprar desde Europa.'
    else 'Hello, I would like to know more options and the steps to buy from Europe.'
  end,
  c.created_at,
  v.stage::public.lead_stage,
  ('00000000-0000-4000-8000-00000000000' || (case when v.n % 2 = 1 then 2 else 3 end))::uuid,
  case when v.stage <> 'new' then c.created_at + make_interval(mins => 20 + (v.n * 53 % 600)) end,
  case when v.stage = 'won' then 150000 + v.n * 5000 end,
  case when v.stage = 'won' then 'USD' end,
  case when v.stage in ('won', 'lost') then c.created_at + interval '30 days' end,
  case when v.stage = 'lost' then 'Decidió esperar un año más' end,
  c.created_at
from (values
  ( 1, 'Lucía Fernández Ruiz',   'ES', 'es', '34', 'Europe/Madrid',    'new'),
  ( 2, 'Markus Weber',           'DE', 'en', '49', 'Europe/Berlin',    'new'),
  ( 3, 'Carlos Navarro Gil',     'ES', 'es', '34', 'Europe/Madrid',    'new'),
  ( 4, 'Elena Moreno Díaz',      'ES', 'es', '34', 'Europe/Madrid',    'new'),
  ( 5, 'Sophie Laurent',         'FR', 'en', '33', 'Europe/Paris',     'new'),
  ( 6, 'Javier Romero Sanz',     'ES', 'es', '34', 'Europe/Madrid',    'new'),
  ( 7, 'Marta Jiménez Pardo',    'ES', 'es', '34', 'Europe/Madrid',    'contacted'),
  ( 8, 'Giulia Ricci',           'IT', 'es', '39', 'Europe/Rome',      'contacted'),
  ( 9, 'Pablo Herrera Vidal',    'ES', 'es', '34', 'Europe/Madrid',    'contacted'),
  (10, 'Thomas Becker',          'DE', 'en', '49', 'Europe/Berlin',    'contacted'),
  (11, 'Ana Belén Castro',       'ES', 'es', '34', 'Europe/Madrid',    'contacted'),
  (12, 'Jorge Martínez Alonso',  'ES', 'es', '34', 'Europe/Madrid',    'contacted'),
  (13, 'Pedro Almeida',          'PT', 'en', '351', 'Europe/Lisbon',   'contacted'),
  (14, 'Laura Ortega Muñoz',     'ES', 'es', '34', 'Europe/Madrid',    'contacted'),
  (15, 'Claire Dubois',          'FR', 'en', '33', 'Europe/Paris',     'contacted'),
  (16, 'Sergio Domínguez León',  'ES', 'es', '34', 'Europe/Madrid',    'contacted'),
  (17, 'Isabel Vega Rubio',      'ES', 'es', '34', 'Europe/Madrid',    'visit_scheduled'),
  (18, 'Daan de Vries',          'NL', 'en', '31', 'Europe/Amsterdam', 'visit_scheduled'),
  (19, 'Raúl Ibáñez Cano',       'ES', 'es', '34', 'Europe/Madrid',    'visit_scheduled'),
  (20, 'Carmen Delgado Prieto',  'ES', 'es', '34', 'Europe/Madrid',    'visit_scheduled'),
  (21, 'James Whitfield',        'GB', 'en', '44', 'Europe/London',    'visit_scheduled'),
  (22, 'Andrés Molina Serrano',  'ES', 'es', '34', 'Europe/Madrid',    'visit_scheduled'),
  (23, 'Francesca Conti',        'IT', 'en', '39', 'Europe/Rome',      'visit_scheduled'),
  (24, 'Rocío Santos Méndez',    'ES', 'es', '34', 'Europe/Madrid',    'visit_scheduled'),
  (25, 'Stefan Hoffmann',        'DE', 'en', '49', 'Europe/Berlin',    'negotiation'),
  (26, 'Diego Ramos Calvo',      'ES', 'es', '34', 'Europe/Madrid',    'negotiation'),
  (27, 'Inés Guerrero Blanco',   'ES', 'es', '34', 'Europe/Madrid',    'negotiation'),
  (28, 'Mariana Cáceres',        'PY', 'es', '595', 'America/Asuncion', 'negotiation'),
  (29, 'Alberto Gallego Ríos',   'ES', 'es', '34', 'Europe/Madrid',    'negotiation'),
  (30, 'Nadia Mertens',          'NL', 'en', '31', 'Europe/Amsterdam', 'negotiation'),
  (31, 'Cristina Vargas Lozano', 'ES', 'es', '34', 'Europe/Madrid',    'won'),
  (32, 'Lorenzo Bianchi',        'IT', 'es', '39', 'Europe/Rome',      'won'),
  (33, 'Víctor Peña Cortés',     'ES', 'es', '34', 'Europe/Madrid',    'won'),
  (34, 'Sara Núñez Iglesias',    'ES', 'es', '34', 'Europe/Madrid',    'won'),
  (35, 'Émile Garnier',          'FR', 'en', '33', 'Europe/Paris',     'lost'),
  (36, 'Hannah Schulz',          'DE', 'en', '49', 'Europe/Berlin',    'lost'),
  (37, 'Fernando Ruiz Toledo',   'ES', 'es', '34', 'Europe/Madrid',    'lost'),
  (38, 'Oliver Hughes',          'GB', 'en', '44', 'Europe/London',    'lost'),
  (39, 'Rafael Benítez Ayala',   'PY', 'es', '595', 'America/Asuncion', 'lost'),
  (40, 'Joana Ferreira',         'PT', 'en', '351', 'Europe/Lisbon',   'lost')
) as v(n, name, country, locale, prefix, tz, stage)
cross join lateral (
  select case
    when v.n <= 6 then now() - make_interval(hours => v.n * 5)   -- unanswered, some past the 2 h SLA
    else now() - make_interval(days => v.n * 4 - 3, hours => v.n % 7)
  end as created_at
) as c;

-- The insert trigger logged 'created' at now(); align it with the backdated lead.
update public.lead_events e
   set created_at = l.created_at
  from public.leads l
 where e.lead_id = l.id and e.type = 'created';

-- Stage history so the funnel and first-response metrics have real paths to read.
insert into public.lead_events (lead_id, type, from_stage, to_stage, actor_id, created_at)
select l.id, 'stage_changed', s.from_stage, s.to_stage, l.assigned_to,
       l.first_response_at + make_interval(days => (s.step - 1) * 3)
  from public.leads l
  cross join lateral (values
    (1, 'new'::public.lead_stage, 'contacted'::public.lead_stage),
    (2, 'contacted', 'visit_scheduled'),
    (3, 'visit_scheduled', 'negotiation'),
    (4, 'negotiation', 'won')
  ) as s(step, from_stage, to_stage)
 where l.stage not in ('new', 'lost')
   and array_position(array['new', 'contacted', 'visit_scheduled', 'negotiation', 'won']::public.lead_stage[], l.stage) > s.step;

insert into public.lead_events (lead_id, type, from_stage, to_stage, actor_id, created_at)
select l.id, 'stage_changed', s.from_stage, s.to_stage, l.assigned_to, l.first_response_at + make_interval(days => s.step * 5)
  from public.leads l
  cross join lateral (values
    (0, 'new'::public.lead_stage, 'contacted'::public.lead_stage),
    (1, 'contacted', 'lost')
  ) as s(step, from_stage, to_stage)
 where l.stage = 'lost';

-- ── Anonymous views (synthetic, deterministic) ───────────────────────────────
select setseed(0.42);
insert into public.property_views (property_id, locale, viewed_at)
select p.id,
       case when random() < 0.6 then 'es' else 'en' end,
       now() - random() * interval '90 days'
  from public.properties p
  cross join lateral generate_series(1, 30 + (p.reference * 37) % 120)
 where p.publication_status = 'published';

-- ── Site settings (real contact data from the client) ────────────────────────
insert into public.site_settings (phone, whatsapp, email, address_line, lead_notification_emails, hero_property_id)
values ('+595 975 500 150', '+595975500150', 'info@edennia.homes',
        'Teniente Malutín 516, Villa Morra, Asunción, Paraguay', array['info@edennia.homes'],
        '10000000-0000-4000-8000-000000000001');

insert into public.site_settings_translations (locale, hero_tagline, hero_microcopy) values
  ('es', 'Tu hogar en Paraguay, acompañado desde España.', array['Asunción', 'Residencia', 'Inversión']),
  ('en', 'Your home in Paraguay, guided from Spain.', array['Asunción', 'Residency', 'Investment']);

-- Illustrative rate for local development only: the admin sets the real one.
insert into public.exchange_rates (base, quote, rate) values ('USD', 'EUR', 0.86);

-- Client-provided arguments. Unpublished until the source and date are verified (PRODUCT.md: nada inventado).
insert into public.investment_facts (key, value, source_url, as_of, sort_order) values
  ('foreign_income_tax', '0 %', 'https://www.set.gov.py', '2026-11-01', 1),
  ('corporate_tax_ire', '10 %', 'https://www.set.gov.py', '2026-11-01', 2),
  ('vat', '5–10 %', 'https://www.set.gov.py', '2026-11-01', 3),
  ('residency', 'Residencia', 'https://www.migraciones.gov.py', '2026-11-01', 4);

insert into public.investment_fact_translations (fact_id, locale, label, body)
select f.id, t.locale, t.label, t.body
  from (values
    ('foreign_income_tax', 'es', 'Impuesto sobre rentas de origen extranjero', 'Paraguay aplica un sistema territorial: las rentas generadas fuera del país no tributan.'),
    ('foreign_income_tax', 'en', 'Tax on foreign-source income', 'Paraguay uses a territorial system: income earned abroad is not taxed.'),
    ('corporate_tax_ire', 'es', 'Impuesto a la renta empresarial (IRE)', 'Tipo general del impuesto a la renta empresarial.'),
    ('corporate_tax_ire', 'en', 'Corporate income tax (IRE)', 'Standard corporate income tax rate.'),
    ('vat', 'es', 'IVA', 'Tipos reducido y general del impuesto al valor agregado.'),
    ('vat', 'en', 'VAT', 'Reduced and standard value-added tax rates.'),
    ('residency', 'es', 'Residencia gestionada', 'Gestionamos tu residencia paraguaya sin coste con la compra de propiedades seleccionadas.'),
    ('residency', 'en', 'Residency handled for you', 'We handle your Paraguayan residency at no cost when you buy selected properties.')
  ) as t(key, locale, label, body)
  join public.investment_facts f on f.key = t.key;
