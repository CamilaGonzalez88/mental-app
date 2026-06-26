// App state and mock data
const appState = {
    currentTab: 'dashboard',
    breathing: {
        active: false,
        timerId: null,
        phase: 0, // 0: Inhale, 1: Hold Full, 2: Exhale, 3: Hold Empty
        timeLeft: 4,
        duration: 4
    },
    grounding: {
        currentStep: 1,
        maxSteps: 5
    },
    moodQuotes: {
        calmo: "Disfruta de este estado de serenidad. Es un buen momento para planificar o simplemente contemplar.",
        feliz: "¡Qué gran día! Comparte tu energía positiva con alguien más o escríbelo en tu diario.",
        ansioso: "La ansiedad es solo una señal biológica. Tu cuerpo está a salvo. Prueba nuestra respiración cuadrada.",
        triste: "Permítete sentir la tristeza; es una emoción válida. Haz algo pequeño y amable por ti hoy.",
        cansado: "Tu cuerpo te está pidiendo un descanso. Respeta tus ritmos y desconéctate un rato."
    },
    clinicians: []
};

// Audio synthesizer for breathing cues (Web Audio API)
let audioCtx = null;
function playAudioCue(frequency = 600, duration = 0.05) {
    try {
        if (!audioCtx) {
            audioCtx = new (window.AudioContext || window.webkitAudioContext)();
        }
        if (audioCtx.state === 'suspended') {
            audioCtx.resume();
        }
        
        const osc = audioCtx.createOscillator();
        const gainNode = audioCtx.createGain();
        
        osc.connect(gainNode);
        gainNode.connect(audioCtx.destination);
        
        osc.frequency.value = frequency;
        osc.type = 'sine';
        
        gainNode.gain.setValueAtTime(0.08, audioCtx.currentTime);
        gainNode.gain.exponentialRampToValueAtTime(0.0001, audioCtx.currentTime + duration);
        
        osc.start(audioCtx.currentTime);
        osc.stop(audioCtx.currentTime + duration);
    } catch (e) {
        console.warn('AudioContext not allowed or supported yet.');
    }
}

// ----------------------------------------------------
// Navigation / Routing
// ----------------------------------------------------
function setupNavigation() {
    document.querySelectorAll('.nav-btn').forEach(btn => {
        btn.addEventListener('click', () => {
            const tabId = btn.getAttribute('data-tab');
            goToTab(tabId);
        });
    });
    
    // Botiquín Sub-tabs
    document.querySelectorAll('.sub-btn').forEach(btn => {
        btn.addEventListener('click', () => {
            const subtabId = btn.getAttribute('data-subtab');
            setActiveSubTab(subtabId);
        });
    });
}

function goToTab(tabId, subtabId = null) {
    document.querySelectorAll('.nav-btn').forEach(btn => {
        if (btn.getAttribute('data-tab') === tabId) {
            btn.classList.add('active');
        } else {
            btn.classList.remove('active');
        }
    });
    
    document.querySelectorAll('.tab-content').forEach(section => {
        if (section.id === tabId) {
            section.classList.add('active');
        } else {
            section.classList.remove('active');
        }
    });
    
    appState.currentTab = tabId;
    
    if (subtabId) {
        setActiveSubTab(subtabId);
    }
    
    // Auto stop breathing if leaving botiquin tab
    if (tabId !== 'botiquin' && appState.breathing.active) {
        stopBreathing();
    }
}

function setActiveSubTab(subtabId) {
    document.querySelectorAll('.sub-btn').forEach(btn => {
        if (btn.getAttribute('data-subtab') === subtabId) {
            btn.classList.add('active');
        } else {
            btn.classList.remove('active');
        }
    });
    
    document.querySelectorAll('.sub-tab-content').forEach(content => {
        if (content.id === subtabId) {
            content.classList.add('active');
        } else {
            content.classList.remove('active');
        }
    });
}

// ----------------------------------------------------
// Mood Tracker Check-in
// ----------------------------------------------------
function setupMoodTracker() {
    const feedbackBox = document.getElementById('checkin-feedback');
    const feedbackText = document.getElementById('feedback-text');
    
    // Load previously selected mood
    const savedMood = localStorage.getItem('mente_conecta_mood');
    if (savedMood) {
        const btn = document.querySelector(`.mood-btn[data-mood="${savedMood}"]`);
        if (btn) btn.classList.add('selected');
        
        feedbackBox.classList.remove('hidden');
        feedbackText.innerText = `Anteriormente seleccionaste: ${savedMood.toUpperCase()}. ${appState.moodQuotes[savedMood]}`;
    }
    
    document.querySelectorAll('.mood-btn').forEach(btn => {
        btn.addEventListener('click', () => {
            document.querySelectorAll('.mood-btn').forEach(b => b.classList.remove('selected'));
            btn.classList.add('selected');
            
            const mood = btn.getAttribute('data-mood');
            localStorage.setItem('mente_conecta_mood', mood);
            
            // Display customized feedback
            feedbackBox.classList.remove('hidden');
            feedbackText.innerText = appState.moodQuotes[mood];
            
            // Play positive soft chime
            playAudioCue(800, 0.15);
        });
    });
}

// ----------------------------------------------------
// Box Breathing (Respiración en Caja)
// ----------------------------------------------------
function setupBreathing() {
    const startBtn = document.getElementById('btn-breathing-start');
    const stopBtn = document.getElementById('btn-breathing-stop');
    
    startBtn.addEventListener('click', startBreathing);
    stopBtn.addEventListener('click', stopBreathing);
}

function startBreathing() {
    if (appState.breathing.active) return;
    
    appState.breathing.active = true;
    appState.breathing.phase = 0;
    appState.breathing.timeLeft = appState.breathing.duration;
    
    document.getElementById('btn-breathing-start').classList.add('hidden');
    document.getElementById('btn-breathing-stop').classList.remove('hidden');
    
    playAudioCue(500, 0.1);
    updateBreathingUI();
    
    appState.breathing.timerId = setInterval(() => {
        appState.breathing.timeLeft--;
        
        if (appState.breathing.timeLeft < 0) {
            // Move to next phase
            appState.breathing.phase = (appState.breathing.phase + 1) % 4;
            appState.breathing.timeLeft = appState.breathing.duration;
            // Play distinct phase chime
            playAudioCue(700, 0.12);
        } else {
            // Normal second tick cue
            playAudioCue(400, 0.03);
        }
        
        updateBreathingUI();
    }, 1000);
}

function stopBreathing() {
    if (!appState.breathing.active) return;
    
    clearInterval(appState.breathing.timerId);
    appState.breathing.active = false;
    
    document.getElementById('btn-breathing-start').classList.remove('hidden');
    document.getElementById('btn-breathing-stop').classList.add('hidden');
    
    // Reset Circle state
    const circle = document.getElementById('breathing-circle');
    circle.className = 'breathing-circle';
    document.getElementById('breathing-phase-text').innerText = "Inicia";
    document.getElementById('breathing-timer').innerText = "4s";
    
    playAudioCue(300, 0.2);
}

function updateBreathingUI() {
    const circle = document.getElementById('breathing-circle');
    const phaseText = document.getElementById('breathing-phase-text');
    const timerText = document.getElementById('breathing-timer');
    
    timerText.innerText = `${appState.breathing.timeLeft}s`;
    
    // Clear phase classes
    circle.classList.remove('inhale', 'hold-full', 'exhale', 'hold-empty');
    
    switch (appState.breathing.phase) {
        case 0:
            phaseText.innerText = "Inhala";
            circle.classList.add('inhale');
            break;
        case 1:
            phaseText.innerText = "Mantén";
            circle.classList.add('hold-full');
            break;
        case 2:
            phaseText.innerText = "Exhala";
            circle.classList.add('exhale');
            break;
        case 3:
            phaseText.innerText = "Vacío";
            circle.classList.add('hold-empty');
            break;
    }
}

// ----------------------------------------------------
// Grounding (5-4-3-2-1 Step Wizard)
// ----------------------------------------------------
function setupGrounding() {
    const nextBtn = document.getElementById('btn-grounding-next');
    const prevBtn = document.getElementById('btn-grounding-prev');
    const restartBtn = document.getElementById('btn-grounding-restart');
    
    nextBtn.addEventListener('click', nextGroundingStep);
    prevBtn.addEventListener('click', prevGroundingStep);
    restartBtn.addEventListener('click', restartGrounding);
    
    updateGroundingUI();
}

function nextGroundingStep() {
    if (appState.grounding.currentStep < appState.grounding.maxSteps) {
        appState.grounding.currentStep++;
        playAudioCue(650, 0.08);
        updateGroundingUI();
    } else if (appState.grounding.currentStep === appState.grounding.maxSteps) {
        appState.grounding.currentStep = 'result';
        playAudioCue(900, 0.25);
        updateGroundingUI();
    }
}

function prevGroundingStep() {
    if (appState.grounding.currentStep === 'result') {
        appState.grounding.currentStep = appState.grounding.maxSteps;
        playAudioCue(450, 0.08);
        updateGroundingUI();
    } else if (appState.grounding.currentStep > 1) {
        appState.grounding.currentStep--;
        playAudioCue(450, 0.08);
        updateGroundingUI();
    }
}

function restartGrounding() {
    appState.grounding.currentStep = 1;
    document.querySelectorAll('.grounding-input').forEach(input => input.value = '');
    playAudioCue(500, 0.1);
    updateGroundingUI();
}

function updateGroundingUI() {
    const steps = document.querySelectorAll('.grounding-step');
    const prevBtn = document.getElementById('btn-grounding-prev');
    const nextBtn = document.getElementById('btn-grounding-next');
    const progressBar = document.getElementById('grounding-progress-bar');
    
    // Hide all steps
    steps.forEach(step => step.classList.remove('active'));
    
    if (appState.grounding.currentStep === 'result') {
        const targetStep = document.querySelector(`.grounding-step[data-step="result"]`);
        if (targetStep) targetStep.classList.add('active');
        
        prevBtn.classList.add('hidden');
        nextBtn.classList.add('hidden');
        progressBar.style.width = '100%';
    } else {
        const targetStep = document.querySelector(`.grounding-step[data-step="${appState.grounding.currentStep}"]`);
        if (targetStep) targetStep.classList.add('active');
        
        // Show/hide prev button
        if (appState.grounding.currentStep === 1) {
            prevBtn.classList.add('hidden');
        } else {
            prevBtn.classList.remove('hidden');
        }
        
        // Change next button text
        if (appState.grounding.currentStep === appState.grounding.maxSteps) {
            nextBtn.innerText = 'Finalizar';
        } else {
            nextBtn.innerText = 'Siguiente';
        }
        
        nextBtn.classList.remove('hidden');
        
        // Update Progress Bar (20% per step)
        const percentage = (appState.grounding.currentStep - 1) * 20 + 20;
        progressBar.style.width = `${percentage}%`;
    }
}

// ----------------------------------------------------
// TCC Micro-Habits Tracker
// ----------------------------------------------------
function setupHabits() {
    const checkboxes = document.querySelectorAll('.habit-checkbox');
    const resetButton = document.getElementById('btn-habits-reset');
    
    // Load saved habits
    const savedHabits = JSON.parse(localStorage.getItem('mente_conecta_habits') || '{}');
    checkboxes.forEach(cb => {
        const habitId = cb.getAttribute('data-habit-id');
        if (savedHabits[habitId]) {
            cb.checked = true;
        }
        
        cb.addEventListener('change', () => {
            savedHabits[habitId] = cb.checked;
            localStorage.setItem('mente_conecta_habits', JSON.stringify(savedHabits));
            
            if (cb.checked) {
                playAudioCue(750, 0.15); // soft check sound
            } else {
                playAudioCue(450, 0.08);
            }
            
            calculateHabitsProgress();
        });
    });
    
    resetButton.addEventListener('click', () => {
        checkboxes.forEach(cb => cb.checked = false);
        localStorage.setItem('mente_conecta_habits', JSON.stringify({}));
        playAudioCue(350, 0.18);
        calculateHabitsProgress();
    });
    
    calculateHabitsProgress();
}

function calculateHabitsProgress() {
    const checkboxes = document.querySelectorAll('.habit-checkbox');
    const total = checkboxes.length;
    let completed = 0;
    
    checkboxes.forEach(cb => {
        if (cb.checked) completed++;
    });
    
    const percentage = total > 0 ? Math.round((completed / total) * 100) : 0;
    
    // Update Dashboard Ring
    document.getElementById('habits-percent').innerText = `${percentage}%`;
    const ring = document.querySelector('.progress-ring-wrapper');
    if (ring) {
        ring.style.background = `conic-gradient(var(--color-secondary) ${percentage}%, rgba(255, 255, 255, 0.05) ${percentage}%)`;
    }
    document.getElementById('habits-count-text').innerText = `${completed} de ${total} completados hoy`;
    
    // Update Habits Subtab Progress Bar
    document.getElementById('habits-card-percent').innerText = `${percentage}%`;
    document.getElementById('habits-card-bar').style.width = `${percentage}%`;
}

// ----------------------------------------------------
// Biblioteca Guides Downloader
// ----------------------------------------------------
const guideContents = {
    'guia-ansiedad': {
        title: 'Guía de Gestión de la Ansiedad',
        html: `
            <p>La ansiedad es una respuesta adaptativa natural ante el peligro. Sin embargo, cuando se activa ante peligros inexistentes o de forma crónica, se vuelve desadaptativa. Esta guía te proporciona herramientas inmediatas para regular tu respuesta biológica.</p>
            <h3>Técnica 1: Reatribución Cognitiva</h3>
            <p>Anota tu pensamiento catastrófico (ej: "Voy a tener un infarto"). Reemplázalo con un hecho racional: "Lo que siento es adrenalina debido a la ansiedad. Es incómodo, pero pasará y estoy a salvo".</p>
            <h3>Técnica 2: Respiración 4-7-8</h3>
            <p>Inhala durante 4s, retén el aire 7s, y exhala sonoramente durante 8s. Repite este ciclo 4 veces para apagar la respuesta de lucha o huida de tu amígdala cerebral.</p>
            <h3>Técnica 3: Distracción con Foco Externo</h3>
            <p>Encuentra 3 objetos de color verde a tu alrededor y descríbelos minuciosamente en tu mente (textura, reflejos, sombras). Esto redirige el foco de atención fuera de tus síntomas internos.</p>
        `
    },
    'higiene-sueno': {
        title: 'Pauta de Higiene del Sueño',
        html: `
            <p>El sueño es el reparador cerebral número uno. Sin una buena arquitectura de sueño, los niveles corporales de cortisol permanecen elevados, facilitando la desregulación emocional.</p>
            <h3>Pautas Claves:</h3>
            <ul>
                <li><strong>Ritmo Circadiano Estricto:</strong> Despiértate y acuéstate a la misma hora todos los días, incluso los fines de semana.</li>
                <li><strong>Bloqueo de Luz Azul:</strong> Apaga móviles, tablets y ordenadores al menos 45 minutos antes de dormir. La luz azul detiene la síntesis de melatonina.</li>
                <li><strong>Temperatura y Ambiente:</strong> Mantén el dormitorio fresco (entre 18°C y 20°C). El cerebro necesita bajar un grado de temperatura para conciliar el sueño profundo.</li>
                <li><strong>Asociación Estímulo-Cama:</strong> Usa la cama únicamente para dormir. Si pasas 20 minutos despierto en la cama, levántate y ve a otra habitación tranquila hasta volver a sentir sueño.</li>
            </ul>
        `
    },
    'registro-tcc': {
        title: 'Plantilla de Registro Diario de Pensamientos (TCC)',
        html: `
            <p>El Registro Diario de Pensamientos (RDP) es la herramienta fundamental de la Terapia Cognitivo Conductual. Te permite objetivar tus pensamientos automáticos distorsionados.</p>
            <table border="1" style="width: 100%; border-collapse: collapse; margin-top: 20px;">
                <thead>
                    <tr style="background-color: #f2f2f2; text-align: left;">
                        <th style="padding: 10px;">1. Situación (¿Qué pasó?)</th>
                        <th style="padding: 10px;">2. Emoción (¿Qué sentiste y cuánto?)</th>
                        <th style="padding: 10px;">3. Pensamiento Automático (¿Qué pensaste?)</th>
                        <th style="padding: 10px;">4. Pensamiento Racional (Respuesta Objetiva)</th>
                    </tr>
                </thead>
                <tbody>
                    <tr>
                        <td style="padding: 10px; height: 100px; vertical-align: top;">Describir el hecho objetivo. Ej: "Mi jefe no contestó mi correo."</td>
                        <td style="padding: 10px; vertical-align: top;">Identificar la emoción. Ej: "Miedo (80%), Tristeza (50%)."</td>
                        <td style="padding: 10px; vertical-align: top;">¿Cuál fue la interpretación? Ej: "Me va a despedir porque hago todo mal."</td>
                        <td style="padding: 10px; vertical-align: top;">Buscar pruebas objetivas a favor y en contra. Ej: "Él está ocupado. Hace 3 días me felicitó."</td>
                    </tr>
                </tbody>
            </table>
        `
    }
};

function downloadResource(guideId) {
    const guide = guideContents[guideId];
    if (!guide) return;
    
    // Load guide into hidden printer template
    document.getElementById('print-title').innerText = guide.title;
    document.getElementById('print-content').innerHTML = guide.html;
    
    // Play print confirmation chime
    playAudioCue(900, 0.2);
    
    // Trigger standard print dialog (allows saving as PDF)
    window.print();
}

// ----------------------------------------------------
// Directorio de Profesionales Filter and Render
// ----------------------------------------------------
function setupDirectory() {
    const searchInput = document.getElementById('directory-search');
    const specialtyFilter = document.getElementById('specialty-filter');
    const volunteerFilter = document.getElementById('volunteer-filter');
    
    searchInput.addEventListener('input', renderDirectory);
    specialtyFilter.addEventListener('change', renderDirectory);
    volunteerFilter.addEventListener('change', renderDirectory);
    
    fetchClinicians();
}

function fetchClinicians() {
    const grid = document.getElementById('directory-grid');
    grid.innerHTML = `
        <div class="card glass" style="grid-column: span 3; text-align: center; padding: 40px;">
            <i class="fa-solid fa-spinner fa-spin" style="font-size: 40px; color: var(--color-secondary); margin-bottom: 16px;"></i>
            <p style="color: var(--text-secondary)">Conectando al servidor y cargando profesionales...</p>
        </div>
    `;

    fetch('http://localhost:8080/api/professionals')
        .then(response => response.json())
        .then(data => {
            appState.clinicians = data.map(p => ({
                name: `${p.nombre} ${p.apellido}`,
                specialty: p.descripcion || "Psicólogo Clínico",
                bio: p.biografia || "Sin descripción disponible.",
                isVolunteer: p.esVoluntario,
                rating: 4.8,
                avatar: `${p.nombre.charAt(0)}${p.apellido.charAt(0)}`
            }));
            renderDirectory();
        })
        .catch(error => {
            console.error('Error fetching professionals:', error);
            grid.innerHTML = `
                <div class="card glass" style="grid-column: span 3; text-align: center; padding: 40px; border-color: var(--color-danger);">
                    <i class="fa-solid fa-triangle-exclamation" style="font-size: 40px; color: var(--color-danger); margin-bottom: 16px;"></i>
                    <h4 style="margin-bottom: 8px;">Error de Conexión</h4>
                    <p style="color: var(--text-secondary); margin-bottom: 16px;">No se pudo conectar al backend de Mente Conecta en http://localhost:8080.</p>
                    <button class="btn btn-secondary btn-sm" onclick="fetchClinicians()">Reintentar Conexión</button>
                </div>
            `;
        });
}

function renderDirectory() {
    const grid = document.getElementById('directory-grid');
    const searchTerm = document.getElementById('directory-search').value.toLowerCase();
    const selectedSpecialty = document.getElementById('specialty-filter').value;
    const onlyVolunteers = document.getElementById('volunteer-filter').checked;
    
    // Filter
    const filtered = appState.clinicians.filter(c => {
        // Search term check
        const matchesSearch = c.name.toLowerCase().includes(searchTerm) || 
                              c.bio.toLowerCase().includes(searchTerm) ||
                              c.specialty.toLowerCase().includes(searchTerm);
                              
        // Specialty check
        const matchesSpecialty = selectedSpecialty === "" || c.specialty === selectedSpecialty;
        
        // Volunteer check
        const matchesVolunteer = !onlyVolunteers || c.isVolunteer;
        
        return matchesSearch && matchesSpecialty && matchesVolunteer;
    });
    
    // Render
    grid.innerHTML = '';
    
    if (filtered.length === 0) {
        grid.innerHTML = `
            <div class="card glass" style="grid-column: span 3; text-align: center; padding: 40px;">
                <i class="fa-solid fa-user-slash" style="font-size: 40px; color: var(--text-secondary); margin-bottom: 16px;"></i>
                <p style="color: var(--text-secondary)">No se encontraron profesionales con los filtros seleccionados.</p>
            </div>
        `;
        return;
    }
    
    filtered.forEach(c => {
        const card = document.createElement('div');
        card.className = 'card glass clinician-card';
        
        card.innerHTML = `
            <div class="clinician-header">
                <div class="clinician-avatar">${c.avatar}</div>
                <div class="clinician-meta">
                    <h4>${c.name}</h4>
                    <span class="clinician-title">${c.specialty}</span>
                    ${c.isVolunteer ? '<span class="badge-volunteer">Voluntario</span>' : ''}
                </div>
            </div>
            <p class="clinician-bio">${c.bio}</p>
            <div class="clinician-footer">
                <span class="rating-badge"><i class="fa-solid fa-star"></i> ${c.rating}</span>
                <button class="btn btn-primary btn-sm" onclick="bookAppointment('${c.name}')">Reservar Cita</button>
            </div>
        `;
        
        grid.appendChild(card);
    });
}

function bookAppointment(name) {
    playAudioCue(880, 0.1);
    alert(`Has solicitado agendar una cita con ${name}. Un correo de confirmación será enviado a ricardo.sanhueza09@inacapmail.cl.`);
}

// ----------------------------------------------------
// Page Initialization
// ----------------------------------------------------
document.addEventListener('DOMContentLoaded', () => {
    setupNavigation();
    setupMoodTracker();
    setupBreathing();
    setupGrounding();
    setupHabits();
    setupDirectory();
});
