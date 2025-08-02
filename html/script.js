window.addEventListener('message', function(event) {
    const data = event.data;
    
    if (data.action === 'show') {
        showLicense(data.licenseData, data.licenseType);
    } else if (data.action === 'hide') {
        hideLicense();
    }
});

function showLicense(licenseData, licenseType) {
    // Hide all containers first
    hideAllLicenses();
    
    if (licenseType === 'driver' || licenseType === 'motorbike') {
        showDriverLicense(licenseData);
    } else if (licenseType === 'truck') {
        showHeavyVehicleLicense(licenseData);
    } else if (licenseType === 'id-card') {
        showProofOfAge(licenseData);
    } else if (licenseType === 'firearms') {
        showFirearmsLicense(licenseData);
    }
    
    // License will stay on screen until R is pressed (no auto-hide)
}

function showDriverLicense(licenseData) {
    // Update license information
    document.getElementById('citizen-name').textContent = licenseData.name || 'JANE CITIZEN';
    document.getElementById('address1').textContent = licenseData.address1 || 'FLAT 10';
    document.getElementById('address2').textContent = licenseData.address2 || '77 SAMPLE PARADE';
    document.getElementById('address3').textContent = licenseData.address3 || 'KEW EAST VIC 3102';
    document.getElementById('expiry-date').textContent = licenseData.expiry || '20-05-2019';
    document.getElementById('birth-date').textContent = licenseData.birthDate || '29-07-1983';
    document.getElementById('license-type').textContent = licenseData.licenseType || 'CAR';
    document.getElementById('conditions').textContent = licenseData.conditions || 'SBEA\\XYZ';
    document.getElementById('license-no').textContent = licenseData.licenseNumber || '987654321';
    document.getElementById('photo-overlay').textContent = licenseData.birthDate?.replace(/-/g, '') || '28071983';
    document.getElementById('signature').textContent = licenseData.signature || licenseData.name || 'Jane Citizen';
    
    // Set photo if available
    const photo = document.getElementById('citizen-photo');
    if (licenseData.photo) {
        photo.src = licenseData.photo;
        photo.style.display = 'block';
    } else {
        photo.style.display = 'none';
    }
    
    // Show the license
    document.getElementById('license-container').classList.remove('hidden');
}

function showProofOfAge(licenseData) {
    // Update proof of age information
    document.getElementById('proof-name').textContent = licenseData.name || 'SAM SAMPLE';
    document.getElementById('proof-address1').textContent = licenseData.address1 || '10 SAMPLE STREET';
    document.getElementById('proof-address2').textContent = licenseData.address2 || 'MELBOURNE, VICTORIA';
    document.getElementById('proof-birth-date').textContent = licenseData.birthDate || '03-09-1989';
    document.getElementById('proof-issue-date').textContent = licenseData.issueDate || '05/03/2019';
    document.getElementById('proof-location').textContent = licenseData.location || '572';
    document.getElementById('proof-card-no').textContent = licenseData.cardNumber || '123456';
    document.getElementById('proof-photo-overlay').textContent = licenseData.birthDate?.replace(/-/g, '') || '20071993';
    
    // Set photo if available
    const photo = document.getElementById('proof-photo');
    if (licenseData.photo) {
        photo.src = licenseData.photo;
        photo.style.display = 'block';
    } else {
        photo.style.display = 'none';
    }
    
    // Show the proof of age card
    document.getElementById('proof-age-container').classList.remove('hidden');
}

function showFirearmsLicense(licenseData) {
    // Update firearms license information
    document.getElementById('firearms-name').textContent = licenseData.name || 'Buster Jones';
    document.getElementById('firearms-conditions').textContent = licenseData.conditions || 'N';
    document.getElementById('firearms-reasons').textContent = licenseData.reasons || 'Sport/Target Shooting';
    document.getElementById('firearms-signature').textContent = licenseData.signature || licenseData.name || 'Buster Jones';
    document.getElementById('firearms-expiry').textContent = licenseData.expiry || '01/01/3002';
    document.getElementById('firearms-license-no').textContent = licenseData.licenseNumber || '113 569 895';
    
    // Set photo if available
    const photo = document.getElementById('firearms-photo');
    if (licenseData.photo) {
        photo.src = licenseData.photo;
        photo.style.display = 'block';
    } else {
        photo.style.display = 'none';
    }
    
    // Show the firearms license
    document.getElementById('firearms-container').classList.remove('hidden');
}

function showHeavyVehicleLicense(licenseData) {
    // Update heavy vehicle license information
    document.getElementById('heavy-vehicle-name').textContent = licenseData.name || 'JAYNE C AMIET';
    document.getElementById('heavy-vehicle-address1').textContent = licenseData.address1 || 'FLAT 10';
    document.getElementById('heavy-vehicle-address2').textContent = licenseData.address2 || '393 RAGLAN ST';
    document.getElementById('heavy-vehicle-expiry').textContent = licenseData.expiry || '21-11-2019';
    document.getElementById('heavy-vehicle-birth-date').textContent = licenseData.birthDate || '02-06-1983';
    document.getElementById('heavy-vehicle-license-type').textContent = licenseData.licenseType || 'CAR HR';
    document.getElementById('heavy-vehicle-conditions').textContent = licenseData.conditions || 'NONE';
    document.getElementById('heavy-vehicle-license-no').textContent = licenseData.licenseNumber || '059120569';
    document.getElementById('heavy-vehicle-photo-overlay').textContent = licenseData.birthDate?.replace(/-/g, '') || '02061983';
    document.getElementById('heavy-vehicle-signature').textContent = licenseData.signature || licenseData.name || 'Jayne C Amiet';
    
    // Set photo if available
    const photo = document.getElementById('heavy-vehicle-photo');
    if (licenseData.photo) {
        photo.src = licenseData.photo;
        photo.style.display = 'block';
    } else {
        photo.style.display = 'none';
    }
    
    // Show the heavy vehicle license
    document.getElementById('heavy-vehicle-container').classList.remove('hidden');
}

function hideAllLicenses() {
    document.getElementById('license-container').classList.add('hidden');
    document.getElementById('proof-age-container').classList.add('hidden');
    document.getElementById('firearms-container').classList.add('hidden');
    document.getElementById('heavy-vehicle-container').classList.add('hidden');
}

function hideLicense() {
    hideAllLicenses();
}

// Remove click to close functionality for better control
// document.addEventListener('click', function(e) {
//     if (e.target.id === 'license-container' || e.target.id === 'proof-age-container' || e.target.id === 'firearms-container') {
//         hideLicense();
//     }
// });

// Key event listeners - ESC, Backspace, and R to close
document.addEventListener('keydown', function(e) {
    if (e.key === 'Escape' || e.key === 'Backspace' || e.key === 'r' || e.key === 'R') {
        hideLicense();
        fetch(`https://${GetParentResourceName()}/close`, {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json',
            },
            body: JSON.stringify({})
        });
    }
});