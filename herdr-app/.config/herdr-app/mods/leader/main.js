// Leader key, like the herdr TUI prefix. keys.json binds ctrl-a to
// mod.open:leader in the terminal section only: while this popup has the
// keyboard no terminal does, so a second ctrl-a reaches on_key_down and is
// sent to the program. The next key runs its action; any other key closes.

import { View, div } from "gpui-kit";
import { v_flex, h_flex } from "gpui-base";
import { run, hc, props, focused, spaces, openOverlay, closeOverlay, theme } from "herdr";

const sendKeys = (terminal, key) => {
  if (!terminal) return;
  hc(["keys", terminal, key]).catch(() => {});
};

// space.new from a script defaults to this computer, so pass the focused
// space's machine to match cmd-n ("" means this computer).
const newSpace = () => {
  const space = spaces().find((s) => s.id === focused()?.space);
  run("space.new", { machine: space?.machine ?? "" });
};

const ADJECTIVES = ["amber", "brave", "bright", "calm", "clever", "cosmic", "crisp", "curious", "dusty", "eager", "fancy", "fuzzy", "gentle", "golden", "happy", "humble", "jolly", "kind", "lively", "lucky", "mellow", "misty", "noble", "polite", "pretty", "proud", "quiet", "rapid", "rustic", "shiny", "silent", "silver", "sleepy", "smooth", "snowy", "spicy", "sunny", "swift", "tidy", "witty"];
const NOUNS = ["acorn", "badger", "breeze", "cake", "canyon", "cedar", "cloud", "comet", "coral", "daisy", "falcon", "fern", "forest", "fox", "garden", "harbor", "island", "lantern", "lemon", "maple", "meadow", "moon", "otter", "panda", "pebble", "pine", "planet", "pond", "rabbit", "raven", "river", "rocket", "sparrow", "stone", "storm", "tiger", "tulip", "valley", "walnut", "willow"];
const pick = (words) => words[Math.floor(Math.random() * words.length)];

// Two random words and the local date, for example "pretty-cake-2026-11-20".
const branchName = () => {
  const now = new Date();
  const date = [now.getFullYear(), now.getMonth() + 1, now.getDate()].map((n) => String(n).padStart(2, "0")).join("-");
  return `${pick(ADJECTIVES)}-${pick(NOUNS)}-${date}`;
};

// The shipped worktree dialog creates the checkout at once when it gets a
// branch. It checks out a branch that already exists instead of creating one.
const newWorktree = () => {
  const at = focused();
  if (!at) return;
  openOverlay({ mod: "worktree", kind: "dialog", width: 460, height: 280, props: { space: at.space, folder: at.cwd ?? undefined, action: "new", branch: branchName() } });
};

const DIGITS =["1", "2", "3", "4", "5", "6", "7", "8", "9"];

// `keys` match a keystroke ("ctrl-l") or the typed character ("&", "\\").
const BINDINGS = [
  { keys: ["c"], label: "new tab", act: () => run("tab.new", {}) },
  { keys: ["n"], label: "next tab", act: () => run("tab.next") },
  { keys: ["p"], label: "previous tab", act: () => run("tab.prev") },
  { keys: DIGITS, show: "1-9", label: "go to tab", act: (_t, key) => run("tab.select", { index: Number(key) }) },
  { keys: ["&"], label: "close tab", act: () => run("tab.close", {}) },
  { keys: ["s"], label: "pick tab", act: () => run("mod.open", { name: "picker" }) },
  { keys: ["shift-n", "N"], show: "shift-n", label: "new space", act: newSpace },
  { keys: ["w"], label: "new worktree", act: newWorktree },
  { keys: ["\\"], label: "split right", act: () => run("pane.split", { direction: "right" }) },
  { keys: ["-"], label: "split down", act: () => run("pane.split", { direction: "down" }) },
  { keys: ["m"], label: "zoom pane", act: () => run("pane.zoom", {}) },
  { keys: ["x"], label: "close pane", act: () => run("pane.close", {}) },
  { keys: ["h"], label: "pane left", act: () => run("pane.go", { direction: "left" }) },
  { keys: ["j"], label: "pane down", act: () => run("pane.go", { direction: "down" }) },
  { keys: ["k"], label: "pane up", act: () => run("pane.go", { direction: "up" }) },
  { keys: ["l"], label: "pane right", act: () => run("pane.go", { direction: "right" }) },
  { keys: ["b"], label: "toggle sidebar", act: () => run("layout.toggle", { id: "sidebar" }) },
  { keys: [","], label: "settings", act: () => run("app.settings", {}) },
  { keys: ["d"], label: "close window", act: () => run("window.close") },
  { keys: ["ctrl-l"], label: "clear screen", act: (t) => sendKeys(t, "ctrl+l") },
  { keys: ["ctrl-a"], label: "send ctrl-a", act: (t) => sendKeys(t, "ctrl+a") },
];

const MODIFIER_KEYS = new Set(["shift", "control", "ctrl", "alt", "platform", "cmd", "function", "fn"]);

const lookup = (e) => {
  const byStroke = BINDINGS.find((b) => b.keys.includes(e.keystroke));
  if (byStroke) return { binding: byStroke, key: e.keystroke };
  const m = e.modifiers;
  if (!e.key_char || m.control || m.alt || m.platform) return null;
  const byChar = BINDINGS.find((b) => b.keys.includes(e.key_char));
  return byChar ? { binding: byChar, key: e.key_char } : null;
};

export default class Leader extends View {
  init(_props, cx) {
    // The terminal that had focus when ctrl-a was pressed, for keys sent back to it.
    this.terminal = focused()?.terminal ?? null;
    this.handle = cx.focus_handle();
    this.handle.focus();
  }

  onKey(e) {
    if (MODIFIER_KEYS.has(e.key)) return;
    const hit = lookup(e);
    closeOverlay(props().overlay);
    if (!hit) return;
    hit.binding.act(this.terminal, hit.key);
  }

  render(_cx) {
    const t = theme();
    const half = Math.ceil(BINDINGS.length / 2);
    const column = (rows) =>
      v_flex().flex_1().gap(2).children(
        rows.map((b) =>
          h_flex()
            .gap(10)
            .items_center()
            .child(div().w(52).text_color(t.accent).font_semibold().child(b.show ?? b.keys[0]))
            .child(div().text_color(t.foreground).truncate().child(b.label)),
        ),
      );
    return v_flex()
      .id("leader")
      .track_focus(this.handle)
      .on_key_down((e, _cx) => this.onKey(e))
      .size_full()
      .p(12)
      .gap(8)
      .bg(t.popover)
      .text_size(12.8)
      .child(div().text_color(t.muted).child("ctrl-a, then a key (Esc to cancel)"))
      .child(h_flex().items_start().gap(16).child(column(BINDINGS.slice(0, half))).child(column(BINDINGS.slice(half))));
  }
}
