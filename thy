      padding: 10px;
            margin-top: 5px;
            border-radius: 4px;
            border: 1px solid #ccc;
            font-size: 16px;
        }

        button {
            background-color: #28a745;
            color: white;
            border: none;
            cursor: pointer;
            transition: background-color 0.3s;
        }

        button:hover {
            background-color: #218838;
        }

        button:disabled {
            background-color: #ccc;
            cursor: not-allowed;
        }

        .ride-list {
            margin-top: 30px;
        }

        .ride-item {
            border-bottom: 1px solid #ddd;
            padding: 15px 10px;
            display: flex;
            flex-direction: column;
            margin-bottom: 10px;
            background-color: #f9f9f9;
            border-radius: 6px;
        }

        .ride-item button {
            width: auto;
            margin-top: 10px;
        }

        .passenger-list {
            margin-top: 10px;
            font-style: italic;
            color: #555;
        }

        .passenger-item {
            margin-left: 20px;
            font-size: 14px;
        }

        @media (max-width: 768px) {
            input, select, button {
                font-size: 14px;
                padding: 8px;
            }

            .ride-item {
                padding: 10px;
            }

            h1, h2 {
                font-size: 20px;
            }
        }

    </style>
</head>
<body>
    <div class="container">
        <h1>Araç Paylaşım Platformu</h1>

        <!-- Araç Paylaşım Formu -->
        <form id="rideForm">
            <h2>Araç Paylaş</h2>
            <label for="name">Adınız:</label>
            <input type="text" id="name" required>

            <label for="phone">İletişim Numarası:</label>
            <input type="text" id="phone" required>

            <label for="seats">Kaç Kişilik:</label>
            <input type="number" id="seats" min="1" required>

            <label for="location">Lokasyon:</label>
            <input type="text" id="location" required>

            <label for="date">Tarih:</label>
            <input type="date" id="date" required>

            <label for="time">Saat:</label>
            <input type="time" id="time" required>

            <button type="submit">Araç Paylaş</button>
        </form>

        <!-- Filtreleme Formu -->
        <div class="filter-form">
            <h2>Mevcut Araçları Filtrele</h2>
            <label for="filterLocation">Lokasyon:</label>
            <input type="text" id="filterLocation">

            <label for="filterDate">Tarih:</label>
            <input type="date" id="filterDate">

            <button onclick="filterRides()">Filtrele</button>
        </div>

        <!-- Paylaşılan Araçlar Listesi -->
        <div class="ride-list" id="rideList">
            <h2>Mevcut Araçlar</h2>
        </div>
    </div>

    <script>
        const rideForm = document.getElementById('rideForm');
        const rideList = document.getElementById('rideList');
        let rides = [];

        // Formu gönderme işlemi
        rideForm.addEventListener('submit', function (e) {
            e.preventDefault();

            const name = document.getElementById('name').value;
            const phone = document.getElementById('phone').value;
            const seats = parseInt(document.getElementById('seats').value);
            const location = document.getElementById('location').value;
            const date = document.getElementById('date').value;
            const time = document.getElementById('time').value;

            const ride = {
                name,
                phone,
                seats,
                availableSeats: seats,
                location,
                date,
                time,
                passengers: []
            };

            rides.push(ride);
            renderRides();
            rideForm.reset();
        });

        // Aracı Listeleme ve Talep Etme İşlemi
        function renderRides() {
            rideList.innerHTML = `<h2>Mevcut Araçlar</h2>`;

            const now = new Date();

            rides = rides.filter(ride => {
                const rideDateTime = new Date(`${ride.date}T${ride.time}`);
                return rideDateTime > now; // Süresi geçmiş araçları kaldır
            });

            rides.forEach((ride, index) => {
                const rideItem = document.createElement('div');
                rideItem.classList.add('ride-item');

                const rideInfo = `
                    <div>
                        <strong>${ride.name} (${ride.phone})</strong><br>
                        Lokasyon: ${ride.location}<br>
                        Tarih: ${ride.date} Saat: ${ride.time}<br>
                        Kişi Kapasitesi: ${ride.seats} - Kalan Yer: ${ride.availableSeats}
                    </div>
                `;

                const requestButton = document.createElement('button');
                requestButton.innerText = 'Araç Talep Et';
                requestButton.disabled = ride.availableSeats === 0;
                if (ride.availableSeats === 0) {
                    requestButton.innerText = 'Dolu';
                }

                requestButton.addEventListener('click', function () {
                    const passengerName = prompt("Adınızı Girin:");
                    const passengerPhone = prompt("İletişim Numaranızı Girin:");

                    if (passengerName && passengerPhone) {
                        ride.passengers.push({ name: passengerName, phone: passengerPhone });
                        ride.availableSeats -= 1;
                        renderRides();
                    }
                });

                rideItem.innerHTML = rideInfo;
                rideItem.appendChild(requestButton);

                // Talep Edenleri Gösterme
                const passengerList = document.createElement('div');
                passengerList.classList.add('passenger-list');
                if (ride.passengers.length > 0) {
                    passengerList.innerHTML = '<strong>Talep Edenler:</strong>';
                    ride.passengers.forEach(passenger => {
                        const passengerItem = document.createElement('div');
                        passengerItem.classList.add('passenger-item');
                        passengerItem.innerText = `${passenger.name} (${passenger.phone})`;
                        passengerList.appendChild(passengerItem);
                    });
                }
                rideItem.appendChild(passengerList);

                rideList.appendChild(rideItem);
            });
        }

        // Listeyi filtreleme işlemi
        function filterRides() {
            const filterLocation = document.getElementById('filterLocation').value.toLowerCase();
            const filterDate = document.getElementById('filterDate').value;

            const filteredRides = rides.filter(ride => {
                const locationMatch = filterLocation ? ride.location.toLowerCase().includes(filterLocation) : true;
                const dateMatch = filterDate ? ride.date === filterDate : true;
                return locationMatch && dateMatch;
            });

            // Filtrelenmiş sonuçları göstermek için listeyi yeniden render et
            rideList.innerHTML = `<h2>Mevcut Araçlar</h2>`;
            filteredRides.forEach((ride, index) => {
                const rideItem = document.createElement('div');
                rideItem.classList.add('ride-item');

                const rideInfo = `
                    <div>
                        <strong>${ride.name} (${ride.phone})</strong><br>
                        Lokasyon: ${ride.location}<br>
                        Tarih: ${ride.date} Saat: ${ride.time}<br>
                        Kişi Kapasitesi: ${ride.seats} - Kalan Yer: ${ride.availableSeats}
                    </div>
                `;

                const requestButton = document.createElement('button');
                requestButton.innerText = 'Araç Talep Et';
                requestButton.disabled = ride.availableSeats === 0;
                if (ride.availableSeats === 0) {
                    requestButton.innerText = 'Dolu';
                }

                requestButton.addEventListener('click', function () {
                    const passengerName = prompt("Adınızı Girin:");
                    const passengerPhone = prompt("İletişim Numaranızı Girin:");

                    if (passengerName && passengerPhone) {
                        ride.passengers.push({ name: passengerName, phone: passengerPhone });
                        ride.availableSeats -= 1;
                        renderRides();
                    }
                });

                rideItem.innerHTML = rideInfo;
                rideItem.appendChild(requestButton);

                // Talep Edenleri Gösterme
                const passengerList = document.createElement('div');
                passengerList.classList.add('passenger-list');
                if (ride.passengers.length > 0) {
                    passengerList.innerHTML = '<strong>Talep Edenler:</strong>';
                    ride.passengers.forEach(passenger => {
                        const passengerItem = document.createElement('div');
                        passengerItem.classList.add('passenger-item');
                        passengerItem.innerText = `${passenger.name} (${passenger.phone})`;
                        passengerList.appendChild(passengerItem);
                    });
                }
                rideItem.appendChild(passengerList);

                rideList.appendChild(rideItem);
                });
                }

                // Zaman kontrolü için interval ile araç listesini düzenli olarak yenileme
                setInterval(renderRides, 60000); // Her dakika bir kez araçları yenile
                </script>
                </body>
                </html>