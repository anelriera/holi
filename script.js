// JavaScript to open the envelope
const envelope = document.querySelector('.envelope');
if (envelope) {
    envelope.addEventListener('click', function () {
        this.classList.toggle('open');
    });
}

let state = false;
const btn = document.querySelector(".btn");
const record = document.querySelector(".record");
const toneArm = document.querySelector(".tone-arm");
const song = document.querySelector(".my-song");
const slider = document.querySelector(".slider");

if (btn && record && toneArm && song && slider) {
    btn.addEventListener("click", () => {
        if (state == false) {
            record.classList.add("on");
            toneArm.classList.add("play");
            setTimeout(() => {
                song.play();
            }, 1000);
        } else {
            record.classList.remove("on");
            toneArm.classList.remove("play");
            song.pause();
        }
        state = !state;
    });

    slider.addEventListener("input", (e) => {
        song.volume = Number(e.target.value);
    });
}
