var __defProp = Object.defineProperty;
var __typeError = (msg) => {
  throw TypeError(msg);
};
var __defNormalProp = (obj, key, value) => key in obj ? __defProp(obj, key, { enumerable: true, configurable: true, writable: true, value }) : obj[key] = value;
var __publicField = (obj, key, value) => __defNormalProp(obj, typeof key !== "symbol" ? key + "" : key, value);
var __accessCheck = (obj, member, msg) => member.has(obj) || __typeError("Cannot " + msg);
var __privateGet = (obj, member, getter) => (__accessCheck(obj, member, "read from private field"), getter ? getter.call(obj) : member.get(obj));
var __privateAdd = (obj, member, value) => member.has(obj) ? __typeError("Cannot add the same private member more than once") : member instanceof WeakSet ? member.add(obj) : member.set(obj, value);
var _theme, _isVisible, _cameraActive;
(function polyfill() {
  const relList = document.createElement("link").relList;
  if (relList && relList.supports && relList.supports("modulepreload")) {
    return;
  }
  for (const link2 of document.querySelectorAll('link[rel="modulepreload"]')) {
    processPreload(link2);
  }
  new MutationObserver((mutations) => {
    for (const mutation of mutations) {
      if (mutation.type !== "childList") {
        continue;
      }
      for (const node of mutation.addedNodes) {
        if (node.tagName === "LINK" && node.rel === "modulepreload")
          processPreload(node);
      }
    }
  }).observe(document, { childList: true, subtree: true });
  function getFetchOpts(link2) {
    const fetchOpts = {};
    if (link2.integrity) fetchOpts.integrity = link2.integrity;
    if (link2.referrerPolicy) fetchOpts.referrerPolicy = link2.referrerPolicy;
    if (link2.crossOrigin === "use-credentials")
      fetchOpts.credentials = "include";
    else if (link2.crossOrigin === "anonymous") fetchOpts.credentials = "omit";
    else fetchOpts.credentials = "same-origin";
    return fetchOpts;
  }
  function processPreload(link2) {
    if (link2.ep)
      return;
    link2.ep = true;
    const fetchOpts = getFetchOpts(link2);
    fetch(link2.href, fetchOpts);
  }
})();
const PUBLIC_VERSION = "5";
if (typeof window !== "undefined")
  (window.__svelte || (window.__svelte = { v: /* @__PURE__ */ new Set() })).v.add(PUBLIC_VERSION);
const EACH_ITEM_REACTIVE = 1;
const EACH_INDEX_REACTIVE = 1 << 1;
const EACH_IS_CONTROLLED = 1 << 2;
const EACH_IS_ANIMATED = 1 << 3;
const EACH_ITEM_IMMUTABLE = 1 << 4;
const PROPS_IS_IMMUTABLE = 1;
const PROPS_IS_RUNES = 1 << 1;
const PROPS_IS_UPDATED = 1 << 2;
const PROPS_IS_BINDABLE = 1 << 3;
const PROPS_IS_LAZY_INITIAL = 1 << 4;
const TEMPLATE_FRAGMENT = 1;
const TEMPLATE_USE_IMPORT_NODE = 1 << 1;
const UNINITIALIZED = Symbol();
const DEV = false;
var is_array = Array.isArray;
var array_from = Array.from;
var define_property = Object.defineProperty;
var get_descriptor = Object.getOwnPropertyDescriptor;
var get_descriptors = Object.getOwnPropertyDescriptors;
var object_prototype = Object.prototype;
var array_prototype = Array.prototype;
var get_prototype_of = Object.getPrototypeOf;
const noop = () => {
};
function run(fn) {
  return fn();
}
function run_all(arr) {
  for (var i = 0; i < arr.length; i++) {
    arr[i]();
  }
}
const DERIVED = 1 << 1;
const EFFECT = 1 << 2;
const RENDER_EFFECT = 1 << 3;
const BLOCK_EFFECT = 1 << 4;
const BRANCH_EFFECT = 1 << 5;
const ROOT_EFFECT = 1 << 6;
const UNOWNED = 1 << 7;
const DISCONNECTED = 1 << 8;
const CLEAN = 1 << 9;
const DIRTY = 1 << 10;
const MAYBE_DIRTY = 1 << 11;
const INERT = 1 << 12;
const DESTROYED = 1 << 13;
const EFFECT_RAN = 1 << 14;
const EFFECT_TRANSPARENT = 1 << 15;
const LEGACY_DERIVED_PROP = 1 << 16;
const HEAD_EFFECT = 1 << 18;
const EFFECT_HAS_DERIVED = 1 << 19;
const STATE_SYMBOL = Symbol("$state");
function equals(value) {
  return value === this.v;
}
function safe_not_equal(a, b) {
  return a != a ? b == b : a !== b || a !== null && typeof a === "object" || typeof a === "function";
}
function safe_equals(value) {
  return !safe_not_equal(value, this.v);
}
function effect_in_teardown(rune) {
  {
    throw new Error("effect_in_teardown");
  }
}
function effect_in_unowned_derived() {
  {
    throw new Error("effect_in_unowned_derived");
  }
}
function effect_orphan(rune) {
  {
    throw new Error("effect_orphan");
  }
}
function effect_update_depth_exceeded() {
  {
    throw new Error("effect_update_depth_exceeded");
  }
}
function props_invalid_value(key) {
  {
    throw new Error("props_invalid_value");
  }
}
function state_descriptors_fixed() {
  {
    throw new Error("state_descriptors_fixed");
  }
}
function state_prototype_fixed() {
  {
    throw new Error("state_prototype_fixed");
  }
}
function state_unsafe_local_read() {
  {
    throw new Error("state_unsafe_local_read");
  }
}
function state_unsafe_mutation() {
  {
    throw new Error("state_unsafe_mutation");
  }
}
function source(v) {
  return {
    f: 0,
    // TODO ideally we could skip this altogether, but it causes type errors
    v,
    reactions: null,
    equals,
    version: 0
  };
}
function state(v) {
  return /* @__PURE__ */ push_derived_source(source(v));
}
// @__NO_SIDE_EFFECTS__
function mutable_source(initial_value, immutable = false) {
  var _a;
  const s = source(initial_value);
  if (!immutable) {
    s.equals = safe_equals;
  }
  if (component_context !== null && component_context.l !== null) {
    ((_a = component_context.l).s ?? (_a.s = [])).push(s);
  }
  return s;
}
// @__NO_SIDE_EFFECTS__
function push_derived_source(source2) {
  if (active_reaction !== null && (active_reaction.f & DERIVED) !== 0) {
    if (derived_sources === null) {
      set_derived_sources([source2]);
    } else {
      derived_sources.push(source2);
    }
  }
  return source2;
}
function set(source2, value) {
  if (active_reaction !== null && is_runes() && (active_reaction.f & (DERIVED | BLOCK_EFFECT)) !== 0 && // If the source was created locally within the current derived, then
  // we allow the mutation.
  (derived_sources === null || !derived_sources.includes(source2))) {
    state_unsafe_mutation();
  }
  return internal_set(source2, value);
}
function internal_set(source2, value) {
  if (!source2.equals(value)) {
    source2.v = value;
    source2.version = increment_version();
    mark_reactions(source2, DIRTY);
    if (is_runes() && active_effect !== null && (active_effect.f & CLEAN) !== 0 && (active_effect.f & BRANCH_EFFECT) === 0) {
      if (new_deps !== null && new_deps.includes(source2)) {
        set_signal_status(active_effect, DIRTY);
        schedule_effect(active_effect);
      } else {
        if (untracked_writes === null) {
          set_untracked_writes([source2]);
        } else {
          untracked_writes.push(source2);
        }
      }
    }
  }
  return value;
}
function mark_reactions(signal, status) {
  var reactions = signal.reactions;
  if (reactions === null) return;
  var runes = is_runes();
  var length = reactions.length;
  for (var i = 0; i < length; i++) {
    var reaction = reactions[i];
    var flags = reaction.f;
    if ((flags & DIRTY) !== 0) continue;
    if (!runes && reaction === active_effect) continue;
    set_signal_status(reaction, status);
    if ((flags & (CLEAN | UNOWNED)) !== 0) {
      if ((flags & DERIVED) !== 0) {
        mark_reactions(
          /** @type {Derived} */
          reaction,
          MAYBE_DIRTY
        );
      } else {
        schedule_effect(
          /** @type {Effect} */
          reaction
        );
      }
    }
  }
}
// @__NO_SIDE_EFFECTS__
function derived(fn) {
  var flags = DERIVED | DIRTY;
  if (active_effect === null) {
    flags |= UNOWNED;
  } else {
    active_effect.f |= EFFECT_HAS_DERIVED;
  }
  const signal = {
    children: null,
    ctx: component_context,
    deps: null,
    equals,
    f: flags,
    fn,
    reactions: null,
    v: (
      /** @type {V} */
      null
    ),
    version: 0,
    parent: active_effect
  };
  if (active_reaction !== null && (active_reaction.f & DERIVED) !== 0) {
    var derived2 = (
      /** @type {Derived} */
      active_reaction
    );
    (derived2.children ?? (derived2.children = [])).push(signal);
  }
  return signal;
}
// @__NO_SIDE_EFFECTS__
function derived_safe_equal(fn) {
  const signal = /* @__PURE__ */ derived(fn);
  signal.equals = safe_equals;
  return signal;
}
function destroy_derived_children(derived2) {
  var children = derived2.children;
  if (children !== null) {
    derived2.children = null;
    for (var i = 0; i < children.length; i += 1) {
      var child2 = children[i];
      if ((child2.f & DERIVED) !== 0) {
        destroy_derived(
          /** @type {Derived} */
          child2
        );
      } else {
        destroy_effect(
          /** @type {Effect} */
          child2
        );
      }
    }
  }
}
function execute_derived(derived2) {
  var value;
  var prev_active_effect = active_effect;
  set_active_effect(derived2.parent);
  {
    try {
      destroy_derived_children(derived2);
      value = update_reaction(derived2);
    } finally {
      set_active_effect(prev_active_effect);
    }
  }
  return value;
}
function update_derived(derived2) {
  var value = execute_derived(derived2);
  var status = (skip_reaction || (derived2.f & UNOWNED) !== 0) && derived2.deps !== null ? MAYBE_DIRTY : CLEAN;
  set_signal_status(derived2, status);
  if (!derived2.equals(value)) {
    derived2.v = value;
    derived2.version = increment_version();
  }
}
function destroy_derived(signal) {
  destroy_derived_children(signal);
  remove_reactions(signal, 0);
  set_signal_status(signal, DESTROYED);
  signal.v = signal.children = signal.deps = signal.ctx = signal.reactions = null;
}
function validate_effect(rune) {
  if (active_effect === null && active_reaction === null) {
    effect_orphan();
  }
  if (active_reaction !== null && (active_reaction.f & UNOWNED) !== 0) {
    effect_in_unowned_derived();
  }
  if (is_destroying_effect) {
    effect_in_teardown();
  }
}
function push_effect(effect2, parent_effect) {
  var parent_last = parent_effect.last;
  if (parent_last === null) {
    parent_effect.last = parent_effect.first = effect2;
  } else {
    parent_last.next = effect2;
    effect2.prev = parent_last;
    parent_effect.last = effect2;
  }
}
function create_effect(type, fn, sync, push2 = true) {
  var is_root = (type & ROOT_EFFECT) !== 0;
  var parent_effect = active_effect;
  var effect2 = {
    ctx: component_context,
    deps: null,
    deriveds: null,
    nodes_start: null,
    nodes_end: null,
    f: type | DIRTY,
    first: null,
    fn,
    last: null,
    next: null,
    parent: is_root ? null : parent_effect,
    prev: null,
    teardown: null,
    transitions: null,
    version: 0
  };
  if (sync) {
    var previously_flushing_effect = is_flushing_effect;
    try {
      set_is_flushing_effect(true);
      update_effect(effect2);
      effect2.f |= EFFECT_RAN;
    } catch (e) {
      destroy_effect(effect2);
      throw e;
    } finally {
      set_is_flushing_effect(previously_flushing_effect);
    }
  } else if (fn !== null) {
    schedule_effect(effect2);
  }
  var inert = sync && effect2.deps === null && effect2.first === null && effect2.nodes_start === null && effect2.teardown === null && (effect2.f & EFFECT_HAS_DERIVED) === 0;
  if (!inert && !is_root && push2) {
    if (parent_effect !== null) {
      push_effect(effect2, parent_effect);
    }
    if (active_reaction !== null && (active_reaction.f & DERIVED) !== 0) {
      var derived2 = (
        /** @type {Derived} */
        active_reaction
      );
      (derived2.children ?? (derived2.children = [])).push(effect2);
    }
  }
  return effect2;
}
function user_effect(fn) {
  validate_effect();
  var defer = active_effect !== null && (active_effect.f & BRANCH_EFFECT) !== 0 && component_context !== null && !component_context.m;
  if (defer) {
    var context = (
      /** @type {ComponentContext} */
      component_context
    );
    (context.e ?? (context.e = [])).push({
      fn,
      effect: active_effect,
      reaction: active_reaction
    });
  } else {
    var signal = effect(fn);
    return signal;
  }
}
function user_pre_effect(fn) {
  validate_effect();
  return render_effect(fn);
}
function effect_root(fn) {
  const effect2 = create_effect(ROOT_EFFECT, fn, true);
  return () => {
    destroy_effect(effect2);
  };
}
function effect(fn) {
  return create_effect(EFFECT, fn, false);
}
function render_effect(fn) {
  return create_effect(RENDER_EFFECT, fn, true);
}
function template_effect(fn) {
  return block(fn);
}
function block(fn, flags = 0) {
  return create_effect(RENDER_EFFECT | BLOCK_EFFECT | flags, fn, true);
}
function branch(fn, push2 = true) {
  return create_effect(RENDER_EFFECT | BRANCH_EFFECT, fn, true, push2);
}
function execute_effect_teardown(effect2) {
  var teardown = effect2.teardown;
  if (teardown !== null) {
    const previously_destroying_effect = is_destroying_effect;
    const previous_reaction = active_reaction;
    set_is_destroying_effect(true);
    set_active_reaction(null);
    try {
      teardown.call(null);
    } finally {
      set_is_destroying_effect(previously_destroying_effect);
      set_active_reaction(previous_reaction);
    }
  }
}
function destroy_effect_deriveds(signal) {
  var deriveds = signal.deriveds;
  if (deriveds !== null) {
    signal.deriveds = null;
    for (var i = 0; i < deriveds.length; i += 1) {
      destroy_derived(deriveds[i]);
    }
  }
}
function destroy_effect_children(signal, remove_dom = false) {
  var effect2 = signal.first;
  signal.first = signal.last = null;
  while (effect2 !== null) {
    var next = effect2.next;
    destroy_effect(effect2, remove_dom);
    effect2 = next;
  }
}
function destroy_block_effect_children(signal) {
  var effect2 = signal.first;
  while (effect2 !== null) {
    var next = effect2.next;
    if ((effect2.f & BRANCH_EFFECT) === 0) {
      destroy_effect(effect2);
    }
    effect2 = next;
  }
}
function destroy_effect(effect2, remove_dom = true) {
  var removed = false;
  if ((remove_dom || (effect2.f & HEAD_EFFECT) !== 0) && effect2.nodes_start !== null) {
    var node = effect2.nodes_start;
    var end = effect2.nodes_end;
    while (node !== null) {
      var next = node === end ? null : (
        /** @type {TemplateNode} */
        /* @__PURE__ */ get_next_sibling(node)
      );
      node.remove();
      node = next;
    }
    removed = true;
  }
  destroy_effect_children(effect2, remove_dom && !removed);
  destroy_effect_deriveds(effect2);
  remove_reactions(effect2, 0);
  set_signal_status(effect2, DESTROYED);
  var transitions = effect2.transitions;
  if (transitions !== null) {
    for (const transition of transitions) {
      transition.stop();
    }
  }
  execute_effect_teardown(effect2);
  var parent = effect2.parent;
  if (parent !== null && parent.first !== null) {
    unlink_effect(effect2);
  }
  effect2.next = effect2.prev = effect2.teardown = effect2.ctx = effect2.deps = effect2.parent = effect2.fn = effect2.nodes_start = effect2.nodes_end = null;
}
function unlink_effect(effect2) {
  var parent = effect2.parent;
  var prev = effect2.prev;
  var next = effect2.next;
  if (prev !== null) prev.next = next;
  if (next !== null) next.prev = prev;
  if (parent !== null) {
    if (parent.first === effect2) parent.first = next;
    if (parent.last === effect2) parent.last = prev;
  }
}
function pause_effect(effect2, callback) {
  var transitions = [];
  pause_children(effect2, transitions, true);
  run_out_transitions(transitions, () => {
    destroy_effect(effect2);
    if (callback) callback();
  });
}
function run_out_transitions(transitions, fn) {
  var remaining = transitions.length;
  if (remaining > 0) {
    var check = () => --remaining || fn();
    for (var transition of transitions) {
      transition.out(check);
    }
  } else {
    fn();
  }
}
function pause_children(effect2, transitions, local) {
  if ((effect2.f & INERT) !== 0) return;
  effect2.f ^= INERT;
  if (effect2.transitions !== null) {
    for (const transition of effect2.transitions) {
      if (transition.is_global || local) {
        transitions.push(transition);
      }
    }
  }
  var child2 = effect2.first;
  while (child2 !== null) {
    var sibling2 = child2.next;
    var transparent = (child2.f & EFFECT_TRANSPARENT) !== 0 || (child2.f & BRANCH_EFFECT) !== 0;
    pause_children(child2, transitions, transparent ? local : false);
    child2 = sibling2;
  }
}
function resume_effect(effect2) {
  resume_children(effect2, true);
}
function resume_children(effect2, local) {
  if ((effect2.f & INERT) === 0) return;
  if (check_dirtiness(effect2)) {
    update_effect(effect2);
  }
  effect2.f ^= INERT;
  var child2 = effect2.first;
  while (child2 !== null) {
    var sibling2 = child2.next;
    var transparent = (child2.f & EFFECT_TRANSPARENT) !== 0 || (child2.f & BRANCH_EFFECT) !== 0;
    resume_children(child2, transparent ? local : false);
    child2 = sibling2;
  }
  if (effect2.transitions !== null) {
    for (const transition of effect2.transitions) {
      if (transition.is_global || local) {
        transition.in();
      }
    }
  }
}
let is_micro_task_queued$1 = false;
let current_queued_micro_tasks = [];
function process_micro_tasks() {
  is_micro_task_queued$1 = false;
  const tasks = current_queued_micro_tasks.slice();
  current_queued_micro_tasks = [];
  run_all(tasks);
}
function queue_micro_task(fn) {
  if (!is_micro_task_queued$1) {
    is_micro_task_queued$1 = true;
    queueMicrotask(process_micro_tasks);
  }
  current_queued_micro_tasks.push(fn);
}
function lifecycle_outside_component(name) {
  {
    throw new Error("lifecycle_outside_component");
  }
}
let is_micro_task_queued = false;
let is_flushing_effect = false;
let is_destroying_effect = false;
function set_is_flushing_effect(value) {
  is_flushing_effect = value;
}
function set_is_destroying_effect(value) {
  is_destroying_effect = value;
}
let queued_root_effects = [];
let flush_count = 0;
let dev_effect_stack = [];
let active_reaction = null;
function set_active_reaction(reaction) {
  active_reaction = reaction;
}
let active_effect = null;
function set_active_effect(effect2) {
  active_effect = effect2;
}
let derived_sources = null;
function set_derived_sources(sources) {
  derived_sources = sources;
}
let new_deps = null;
let skipped_deps = 0;
let untracked_writes = null;
function set_untracked_writes(value) {
  untracked_writes = value;
}
let current_version = 0;
let skip_reaction = false;
let component_context = null;
function increment_version() {
  return ++current_version;
}
function is_runes() {
  return component_context !== null && component_context.l === null;
}
function check_dirtiness(reaction) {
  var _a, _b;
  var flags = reaction.f;
  if ((flags & DIRTY) !== 0) {
    return true;
  }
  if ((flags & MAYBE_DIRTY) !== 0) {
    var dependencies = reaction.deps;
    var is_unowned = (flags & UNOWNED) !== 0;
    if (dependencies !== null) {
      var i;
      if ((flags & DISCONNECTED) !== 0) {
        for (i = 0; i < dependencies.length; i++) {
          ((_a = dependencies[i]).reactions ?? (_a.reactions = [])).push(reaction);
        }
        reaction.f ^= DISCONNECTED;
      }
      for (i = 0; i < dependencies.length; i++) {
        var dependency = dependencies[i];
        if (check_dirtiness(
          /** @type {Derived} */
          dependency
        )) {
          update_derived(
            /** @type {Derived} */
            dependency
          );
        }
        if (is_unowned && active_effect !== null && !skip_reaction && !((_b = dependency == null ? void 0 : dependency.reactions) == null ? void 0 : _b.includes(reaction))) {
          (dependency.reactions ?? (dependency.reactions = [])).push(reaction);
        }
        if (dependency.version > reaction.version) {
          return true;
        }
      }
    }
    if (!is_unowned) {
      set_signal_status(reaction, CLEAN);
    }
  }
  return false;
}
function handle_error(error, effect2, component_context2) {
  {
    throw error;
  }
}
function update_reaction(reaction) {
  var _a;
  var previous_deps = new_deps;
  var previous_skipped_deps = skipped_deps;
  var previous_untracked_writes = untracked_writes;
  var previous_reaction = active_reaction;
  var previous_skip_reaction = skip_reaction;
  var prev_derived_sources = derived_sources;
  var previous_component_context = component_context;
  var flags = reaction.f;
  new_deps = /** @type {null | Value[]} */
  null;
  skipped_deps = 0;
  untracked_writes = null;
  active_reaction = (flags & (BRANCH_EFFECT | ROOT_EFFECT)) === 0 ? reaction : null;
  skip_reaction = !is_flushing_effect && (flags & UNOWNED) !== 0;
  derived_sources = null;
  component_context = reaction.ctx;
  try {
    var result = (
      /** @type {Function} */
      (0, reaction.fn)()
    );
    var deps = reaction.deps;
    if (new_deps !== null) {
      var i;
      remove_reactions(reaction, skipped_deps);
      if (deps !== null && skipped_deps > 0) {
        deps.length = skipped_deps + new_deps.length;
        for (i = 0; i < new_deps.length; i++) {
          deps[skipped_deps + i] = new_deps[i];
        }
      } else {
        reaction.deps = deps = new_deps;
      }
      if (!skip_reaction) {
        for (i = skipped_deps; i < deps.length; i++) {
          ((_a = deps[i]).reactions ?? (_a.reactions = [])).push(reaction);
        }
      }
    } else if (deps !== null && skipped_deps < deps.length) {
      remove_reactions(reaction, skipped_deps);
      deps.length = skipped_deps;
    }
    return result;
  } finally {
    new_deps = previous_deps;
    skipped_deps = previous_skipped_deps;
    untracked_writes = previous_untracked_writes;
    active_reaction = previous_reaction;
    skip_reaction = previous_skip_reaction;
    derived_sources = prev_derived_sources;
    component_context = previous_component_context;
  }
}
function remove_reaction(signal, dependency) {
  let reactions = dependency.reactions;
  if (reactions !== null) {
    var index2 = reactions.indexOf(signal);
    if (index2 !== -1) {
      var new_length = reactions.length - 1;
      if (new_length === 0) {
        reactions = dependency.reactions = null;
      } else {
        reactions[index2] = reactions[new_length];
        reactions.pop();
      }
    }
  }
  if (reactions === null && (dependency.f & DERIVED) !== 0 && // Destroying a child effect while updating a parent effect can cause a dependency to appear
  // to be unused, when in fact it is used by the currently-updating parent. Checking `new_deps`
  // allows us to skip the expensive work of disconnecting and immediately reconnecting it
  (new_deps === null || !new_deps.includes(dependency))) {
    set_signal_status(dependency, MAYBE_DIRTY);
    if ((dependency.f & (UNOWNED | DISCONNECTED)) === 0) {
      dependency.f ^= DISCONNECTED;
    }
    remove_reactions(
      /** @type {Derived} **/
      dependency,
      0
    );
  }
}
function remove_reactions(signal, start_index) {
  var dependencies = signal.deps;
  if (dependencies === null) return;
  for (var i = start_index; i < dependencies.length; i++) {
    remove_reaction(signal, dependencies[i]);
  }
}
function update_effect(effect2) {
  var flags = effect2.f;
  if ((flags & DESTROYED) !== 0) {
    return;
  }
  set_signal_status(effect2, CLEAN);
  var previous_effect = active_effect;
  active_effect = effect2;
  try {
    if ((flags & BLOCK_EFFECT) !== 0) {
      destroy_block_effect_children(effect2);
    } else {
      destroy_effect_children(effect2);
    }
    destroy_effect_deriveds(effect2);
    execute_effect_teardown(effect2);
    var teardown = update_reaction(effect2);
    effect2.teardown = typeof teardown === "function" ? teardown : null;
    effect2.version = current_version;
    if (DEV) ;
  } catch (error) {
    handle_error(
      /** @type {Error} */
      error
    );
  } finally {
    active_effect = previous_effect;
  }
}
function infinite_loop_guard() {
  if (flush_count > 1e3) {
    flush_count = 0;
    {
      effect_update_depth_exceeded();
    }
  }
  flush_count++;
}
function flush_queued_root_effects(root_effects) {
  var length = root_effects.length;
  if (length === 0) {
    return;
  }
  infinite_loop_guard();
  var previously_flushing_effect = is_flushing_effect;
  is_flushing_effect = true;
  try {
    for (var i = 0; i < length; i++) {
      var effect2 = root_effects[i];
      if ((effect2.f & CLEAN) === 0) {
        effect2.f ^= CLEAN;
      }
      var collected_effects = [];
      process_effects(effect2, collected_effects);
      flush_queued_effects(collected_effects);
    }
  } finally {
    is_flushing_effect = previously_flushing_effect;
  }
}
function flush_queued_effects(effects) {
  var length = effects.length;
  if (length === 0) return;
  for (var i = 0; i < length; i++) {
    var effect2 = effects[i];
    if ((effect2.f & (DESTROYED | INERT)) === 0 && check_dirtiness(effect2)) {
      update_effect(effect2);
      if (effect2.deps === null && effect2.first === null && effect2.nodes_start === null) {
        if (effect2.teardown === null) {
          unlink_effect(effect2);
        } else {
          effect2.fn = null;
        }
      }
    }
  }
}
function process_deferred() {
  is_micro_task_queued = false;
  if (flush_count > 1001) {
    return;
  }
  const previous_queued_root_effects = queued_root_effects;
  queued_root_effects = [];
  flush_queued_root_effects(previous_queued_root_effects);
  if (!is_micro_task_queued) {
    flush_count = 0;
  }
}
function schedule_effect(signal) {
  {
    if (!is_micro_task_queued) {
      is_micro_task_queued = true;
      queueMicrotask(process_deferred);
    }
  }
  var effect2 = signal;
  while (effect2.parent !== null) {
    effect2 = effect2.parent;
    var flags = effect2.f;
    if ((flags & (ROOT_EFFECT | BRANCH_EFFECT)) !== 0) {
      if ((flags & CLEAN) === 0) return;
      effect2.f ^= CLEAN;
    }
  }
  queued_root_effects.push(effect2);
}
function process_effects(effect2, collected_effects) {
  var current_effect = effect2.first;
  var effects = [];
  main_loop: while (current_effect !== null) {
    var flags = current_effect.f;
    var is_branch = (flags & BRANCH_EFFECT) !== 0;
    var is_skippable_branch = is_branch && (flags & CLEAN) !== 0;
    if (!is_skippable_branch && (flags & INERT) === 0) {
      if ((flags & RENDER_EFFECT) !== 0) {
        if (is_branch) {
          current_effect.f ^= CLEAN;
        } else if (check_dirtiness(current_effect)) {
          update_effect(current_effect);
        }
        var child2 = current_effect.first;
        if (child2 !== null) {
          current_effect = child2;
          continue;
        }
      } else if ((flags & EFFECT) !== 0) {
        effects.push(current_effect);
      }
    }
    var sibling2 = current_effect.next;
    if (sibling2 === null) {
      let parent = current_effect.parent;
      while (parent !== null) {
        if (effect2 === parent) {
          break main_loop;
        }
        var parent_sibling = parent.next;
        if (parent_sibling !== null) {
          current_effect = parent_sibling;
          continue main_loop;
        }
        parent = parent.parent;
      }
    }
    current_effect = sibling2;
  }
  for (var i = 0; i < effects.length; i++) {
    child2 = effects[i];
    collected_effects.push(child2);
    process_effects(child2, collected_effects);
  }
}
function get(signal) {
  var _a;
  var flags = signal.f;
  var is_derived = (flags & DERIVED) !== 0;
  if (is_derived && (flags & DESTROYED) !== 0) {
    var value = execute_derived(
      /** @type {Derived} */
      signal
    );
    destroy_derived(
      /** @type {Derived} */
      signal
    );
    return value;
  }
  if (active_reaction !== null) {
    if (derived_sources !== null && derived_sources.includes(signal)) {
      state_unsafe_local_read();
    }
    var deps = active_reaction.deps;
    if (new_deps === null && deps !== null && deps[skipped_deps] === signal) {
      skipped_deps++;
    } else if (new_deps === null) {
      new_deps = [signal];
    } else {
      new_deps.push(signal);
    }
    if (untracked_writes !== null && active_effect !== null && (active_effect.f & CLEAN) !== 0 && (active_effect.f & BRANCH_EFFECT) === 0 && untracked_writes.includes(signal)) {
      set_signal_status(active_effect, DIRTY);
      schedule_effect(active_effect);
    }
  } else if (is_derived && /** @type {Derived} */
  signal.deps === null) {
    var derived2 = (
      /** @type {Derived} */
      signal
    );
    var parent = derived2.parent;
    if (parent !== null && !((_a = parent.deriveds) == null ? void 0 : _a.includes(derived2))) {
      (parent.deriveds ?? (parent.deriveds = [])).push(derived2);
    }
  }
  if (is_derived) {
    derived2 = /** @type {Derived} */
    signal;
    if (check_dirtiness(derived2)) {
      update_derived(derived2);
    }
  }
  return signal.v;
}
function untrack(fn) {
  const previous_reaction = active_reaction;
  try {
    active_reaction = null;
    return fn();
  } finally {
    active_reaction = previous_reaction;
  }
}
const STATUS_MASK = -3585;
function set_signal_status(signal, status) {
  signal.f = signal.f & STATUS_MASK | status;
}
function push(props, runes = false, fn) {
  component_context = {
    p: component_context,
    c: null,
    e: null,
    m: false,
    s: props,
    x: null,
    l: null
  };
  if (!runes) {
    component_context.l = {
      s: null,
      u: null,
      r1: [],
      r2: source(false)
    };
  }
}
function pop(component) {
  const context_stack_item = component_context;
  if (context_stack_item !== null) {
    const component_effects = context_stack_item.e;
    if (component_effects !== null) {
      var previous_effect = active_effect;
      var previous_reaction = active_reaction;
      context_stack_item.e = null;
      try {
        for (var i = 0; i < component_effects.length; i++) {
          var component_effect = component_effects[i];
          set_active_effect(component_effect.effect);
          set_active_reaction(component_effect.reaction);
          effect(component_effect.fn);
        }
      } finally {
        set_active_effect(previous_effect);
        set_active_reaction(previous_reaction);
      }
    }
    component_context = context_stack_item.p;
    context_stack_item.m = true;
  }
  return (
    /** @type {T} */
    {}
  );
}
function deep_read_state(value) {
  if (typeof value !== "object" || !value || value instanceof EventTarget) {
    return;
  }
  if (STATE_SYMBOL in value) {
    deep_read(value);
  } else if (!Array.isArray(value)) {
    for (let key in value) {
      const prop2 = value[key];
      if (typeof prop2 === "object" && prop2 && STATE_SYMBOL in prop2) {
        deep_read(prop2);
      }
    }
  }
}
function deep_read(value, visited = /* @__PURE__ */ new Set()) {
  if (typeof value === "object" && value !== null && // We don't want to traverse DOM elements
  !(value instanceof EventTarget) && !visited.has(value)) {
    visited.add(value);
    if (value instanceof Date) {
      value.getTime();
    }
    for (let key in value) {
      try {
        deep_read(value[key], visited);
      } catch (e) {
      }
    }
    const proto = get_prototype_of(value);
    if (proto !== Object.prototype && proto !== Array.prototype && proto !== Map.prototype && proto !== Set.prototype && proto !== Date.prototype) {
      const descriptors = get_descriptors(proto);
      for (let key in descriptors) {
        const get2 = descriptors[key].get;
        if (get2) {
          try {
            get2.call(value);
          } catch (e) {
          }
        }
      }
    }
  }
}
function proxy(value, parent = null, prev) {
  if (typeof value !== "object" || value === null || STATE_SYMBOL in value) {
    return value;
  }
  const prototype = get_prototype_of(value);
  if (prototype !== object_prototype && prototype !== array_prototype) {
    return value;
  }
  var sources = /* @__PURE__ */ new Map();
  var is_proxied_array = is_array(value);
  var version = source(0);
  if (is_proxied_array) {
    sources.set("length", source(
      /** @type {any[]} */
      value.length
    ));
  }
  var metadata;
  return new Proxy(
    /** @type {any} */
    value,
    {
      defineProperty(_, prop2, descriptor) {
        if (!("value" in descriptor) || descriptor.configurable === false || descriptor.enumerable === false || descriptor.writable === false) {
          state_descriptors_fixed();
        }
        var s = sources.get(prop2);
        if (s === void 0) {
          s = source(descriptor.value);
          sources.set(prop2, s);
        } else {
          set(s, proxy(descriptor.value, metadata));
        }
        return true;
      },
      deleteProperty(target, prop2) {
        var s = sources.get(prop2);
        if (s === void 0) {
          if (prop2 in target) {
            sources.set(prop2, source(UNINITIALIZED));
          }
        } else {
          if (is_proxied_array && typeof prop2 === "string") {
            var ls = (
              /** @type {Source<number>} */
              sources.get("length")
            );
            var n = Number(prop2);
            if (Number.isInteger(n) && n < ls.v) {
              set(ls, n);
            }
          }
          set(s, UNINITIALIZED);
          update_version(version);
        }
        return true;
      },
      get(target, prop2, receiver) {
        var _a;
        if (prop2 === STATE_SYMBOL) {
          return value;
        }
        var s = sources.get(prop2);
        var exists = prop2 in target;
        if (s === void 0 && (!exists || ((_a = get_descriptor(target, prop2)) == null ? void 0 : _a.writable))) {
          s = source(proxy(exists ? target[prop2] : UNINITIALIZED, metadata));
          sources.set(prop2, s);
        }
        if (s !== void 0) {
          var v = get(s);
          return v === UNINITIALIZED ? void 0 : v;
        }
        return Reflect.get(target, prop2, receiver);
      },
      getOwnPropertyDescriptor(target, prop2) {
        var descriptor = Reflect.getOwnPropertyDescriptor(target, prop2);
        if (descriptor && "value" in descriptor) {
          var s = sources.get(prop2);
          if (s) descriptor.value = get(s);
        } else if (descriptor === void 0) {
          var source2 = sources.get(prop2);
          var value2 = source2 == null ? void 0 : source2.v;
          if (source2 !== void 0 && value2 !== UNINITIALIZED) {
            return {
              enumerable: true,
              configurable: true,
              value: value2,
              writable: true
            };
          }
        }
        return descriptor;
      },
      has(target, prop2) {
        var _a;
        if (prop2 === STATE_SYMBOL) {
          return true;
        }
        var s = sources.get(prop2);
        var has = s !== void 0 && s.v !== UNINITIALIZED || Reflect.has(target, prop2);
        if (s !== void 0 || active_effect !== null && (!has || ((_a = get_descriptor(target, prop2)) == null ? void 0 : _a.writable))) {
          if (s === void 0) {
            s = source(has ? proxy(target[prop2], metadata) : UNINITIALIZED);
            sources.set(prop2, s);
          }
          var value2 = get(s);
          if (value2 === UNINITIALIZED) {
            return false;
          }
        }
        return has;
      },
      set(target, prop2, value2, receiver) {
        var _a;
        var s = sources.get(prop2);
        var has = prop2 in target;
        if (is_proxied_array && prop2 === "length") {
          for (var i = value2; i < /** @type {Source<number>} */
          s.v; i += 1) {
            var other_s = sources.get(i + "");
            if (other_s !== void 0) {
              set(other_s, UNINITIALIZED);
            } else if (i in target) {
              other_s = source(UNINITIALIZED);
              sources.set(i + "", other_s);
            }
          }
        }
        if (s === void 0) {
          if (!has || ((_a = get_descriptor(target, prop2)) == null ? void 0 : _a.writable)) {
            s = source(void 0);
            set(s, proxy(value2, metadata));
            sources.set(prop2, s);
          }
        } else {
          has = s.v !== UNINITIALIZED;
          set(s, proxy(value2, metadata));
        }
        var descriptor = Reflect.getOwnPropertyDescriptor(target, prop2);
        if (descriptor == null ? void 0 : descriptor.set) {
          descriptor.set.call(receiver, value2);
        }
        if (!has) {
          if (is_proxied_array && typeof prop2 === "string") {
            var ls = (
              /** @type {Source<number>} */
              sources.get("length")
            );
            var n = Number(prop2);
            if (Number.isInteger(n) && n >= ls.v) {
              set(ls, n + 1);
            }
          }
          update_version(version);
        }
        return true;
      },
      ownKeys(target) {
        get(version);
        var own_keys = Reflect.ownKeys(target).filter((key2) => {
          var source3 = sources.get(key2);
          return source3 === void 0 || source3.v !== UNINITIALIZED;
        });
        for (var [key, source2] of sources) {
          if (source2.v !== UNINITIALIZED && !(key in target)) {
            own_keys.push(key);
          }
        }
        return own_keys;
      },
      setPrototypeOf() {
        state_prototype_fixed();
      }
    }
  );
}
function update_version(signal, d = 1) {
  set(signal, signal.v + d);
}
function get_proxied_value(value) {
  if (value !== null && typeof value === "object" && STATE_SYMBOL in value) {
    return value[STATE_SYMBOL];
  }
  return value;
}
function is(a, b) {
  return Object.is(get_proxied_value(a), get_proxied_value(b));
}
var $window;
var first_child_getter;
var next_sibling_getter;
function init_operations() {
  if ($window !== void 0) {
    return;
  }
  $window = window;
  var element_prototype = Element.prototype;
  var node_prototype = Node.prototype;
  first_child_getter = get_descriptor(node_prototype, "firstChild").get;
  next_sibling_getter = get_descriptor(node_prototype, "nextSibling").get;
  element_prototype.__click = void 0;
  element_prototype.__className = "";
  element_prototype.__attributes = null;
  element_prototype.__styles = null;
  element_prototype.__e = void 0;
  Text.prototype.__t = void 0;
}
function create_text(value = "") {
  return document.createTextNode(value);
}
// @__NO_SIDE_EFFECTS__
function get_first_child(node) {
  return first_child_getter.call(node);
}
// @__NO_SIDE_EFFECTS__
function get_next_sibling(node) {
  return next_sibling_getter.call(node);
}
function child(node, is_text) {
  {
    return /* @__PURE__ */ get_first_child(node);
  }
}
function first_child(fragment, is_text) {
  {
    var first = (
      /** @type {DocumentFragment} */
      /* @__PURE__ */ get_first_child(
        /** @type {Node} */
        fragment
      )
    );
    if (first instanceof Comment && first.data === "") return /* @__PURE__ */ get_next_sibling(first);
    return first;
  }
}
function sibling(node, count = 1, is_text = false) {
  let next_sibling = node;
  while (count--) {
    next_sibling = /** @type {TemplateNode} */
    /* @__PURE__ */ get_next_sibling(next_sibling);
  }
  {
    return next_sibling;
  }
}
function clear_text_content(node) {
  node.textContent = "";
}
let hydrating = false;
const all_registered_events = /* @__PURE__ */ new Set();
const root_event_handles = /* @__PURE__ */ new Set();
function delegate(events) {
  for (var i = 0; i < events.length; i++) {
    all_registered_events.add(events[i]);
  }
  for (var fn of root_event_handles) {
    fn(events);
  }
}
function handle_event_propagation(event) {
  var _a;
  var handler_element = this;
  var owner_document = (
    /** @type {Node} */
    handler_element.ownerDocument
  );
  var event_name = event.type;
  var path = ((_a = event.composedPath) == null ? void 0 : _a.call(event)) || [];
  var current_target = (
    /** @type {null | Element} */
    path[0] || event.target
  );
  var path_idx = 0;
  var handled_at = event.__root;
  if (handled_at) {
    var at_idx = path.indexOf(handled_at);
    if (at_idx !== -1 && (handler_element === document || handler_element === /** @type {any} */
    window)) {
      event.__root = handler_element;
      return;
    }
    var handler_idx = path.indexOf(handler_element);
    if (handler_idx === -1) {
      return;
    }
    if (at_idx <= handler_idx) {
      path_idx = at_idx;
    }
  }
  current_target = /** @type {Element} */
  path[path_idx] || event.target;
  if (current_target === handler_element) return;
  define_property(event, "currentTarget", {
    configurable: true,
    get() {
      return current_target || owner_document;
    }
  });
  var previous_reaction = active_reaction;
  var previous_effect = active_effect;
  set_active_reaction(null);
  set_active_effect(null);
  try {
    var throw_error;
    var other_errors = [];
    while (current_target !== null) {
      var parent_element = current_target.assignedSlot || current_target.parentNode || /** @type {any} */
      current_target.host || null;
      try {
        var delegated = current_target["__" + event_name];
        if (delegated !== void 0 && !/** @type {any} */
        current_target.disabled) {
          if (is_array(delegated)) {
            var [fn, ...data] = delegated;
            fn.apply(current_target, [event, ...data]);
          } else {
            delegated.call(current_target, event);
          }
        }
      } catch (error) {
        if (throw_error) {
          other_errors.push(error);
        } else {
          throw_error = error;
        }
      }
      if (event.cancelBubble || parent_element === handler_element || parent_element === null) {
        break;
      }
      current_target = parent_element;
    }
    if (throw_error) {
      for (let error of other_errors) {
        queueMicrotask(() => {
          throw error;
        });
      }
      throw throw_error;
    }
  } finally {
    event.__root = handler_element;
    delete event.currentTarget;
    set_active_reaction(previous_reaction);
    set_active_effect(previous_effect);
  }
}
function create_fragment_from_html(html) {
  var elem = document.createElement("template");
  elem.innerHTML = html;
  return elem.content;
}
function assign_nodes(start, end) {
  var effect2 = (
    /** @type {Effect} */
    active_effect
  );
  if (effect2.nodes_start === null) {
    effect2.nodes_start = start;
    effect2.nodes_end = end;
  }
}
// @__NO_SIDE_EFFECTS__
function template(content, flags) {
  var is_fragment = (flags & TEMPLATE_FRAGMENT) !== 0;
  var use_import_node = (flags & TEMPLATE_USE_IMPORT_NODE) !== 0;
  var node;
  var has_start = !content.startsWith("<!>");
  return () => {
    if (node === void 0) {
      node = create_fragment_from_html(has_start ? content : "<!>" + content);
      if (!is_fragment) node = /** @type {Node} */
      /* @__PURE__ */ get_first_child(node);
    }
    var clone = (
      /** @type {TemplateNode} */
      use_import_node ? document.importNode(node, true) : node.cloneNode(true)
    );
    if (is_fragment) {
      var start = (
        /** @type {TemplateNode} */
        /* @__PURE__ */ get_first_child(clone)
      );
      var end = (
        /** @type {TemplateNode} */
        clone.lastChild
      );
      assign_nodes(start, end);
    } else {
      assign_nodes(clone, clone);
    }
    return clone;
  };
}
function text(value = "") {
  {
    var t = create_text(value + "");
    assign_nodes(t, t);
    return t;
  }
}
function comment() {
  var frag = document.createDocumentFragment();
  var start = document.createComment("");
  var anchor = create_text();
  frag.append(start, anchor);
  assign_nodes(start, anchor);
  return frag;
}
function append(anchor, dom) {
  if (anchor === null) {
    return;
  }
  anchor.before(
    /** @type {Node} */
    dom
  );
}
const PASSIVE_EVENTS = ["touchstart", "touchmove"];
function is_passive_event(name) {
  return PASSIVE_EVENTS.includes(name);
}
function set_text(text2, value) {
  var str = value == null ? "" : typeof value === "object" ? value + "" : value;
  if (str !== (text2.__t ?? (text2.__t = text2.nodeValue))) {
    text2.__t = str;
    text2.nodeValue = str == null ? "" : str + "";
  }
}
function mount(component, options) {
  return _mount(component, options);
}
const document_listeners = /* @__PURE__ */ new Map();
function _mount(Component, { target, anchor, props = {}, events, context, intro = true }) {
  init_operations();
  var registered_events = /* @__PURE__ */ new Set();
  var event_handle = (events2) => {
    for (var i = 0; i < events2.length; i++) {
      var event_name = events2[i];
      if (registered_events.has(event_name)) continue;
      registered_events.add(event_name);
      var passive = is_passive_event(event_name);
      target.addEventListener(event_name, handle_event_propagation, { passive });
      var n = document_listeners.get(event_name);
      if (n === void 0) {
        document.addEventListener(event_name, handle_event_propagation, { passive });
        document_listeners.set(event_name, 1);
      } else {
        document_listeners.set(event_name, n + 1);
      }
    }
  };
  event_handle(array_from(all_registered_events));
  root_event_handles.add(event_handle);
  var component = void 0;
  var unmount = effect_root(() => {
    var anchor_node = anchor ?? target.appendChild(create_text());
    branch(() => {
      if (context) {
        push({});
        var ctx = (
          /** @type {ComponentContext} */
          component_context
        );
        ctx.c = context;
      }
      if (events) {
        props.$$events = events;
      }
      component = Component(anchor_node, props) || {};
      if (context) {
        pop();
      }
    });
    return () => {
      var _a;
      for (var event_name of registered_events) {
        target.removeEventListener(event_name, handle_event_propagation);
        var n = (
          /** @type {number} */
          document_listeners.get(event_name)
        );
        if (--n === 0) {
          document.removeEventListener(event_name, handle_event_propagation);
          document_listeners.delete(event_name);
        } else {
          document_listeners.set(event_name, n);
        }
      }
      root_event_handles.delete(event_handle);
      mounted_components.delete(component);
      if (anchor_node !== anchor) {
        (_a = anchor_node.parentNode) == null ? void 0 : _a.removeChild(anchor_node);
      }
    };
  });
  mounted_components.set(component, unmount);
  return component;
}
let mounted_components = /* @__PURE__ */ new WeakMap();
function if_block(node, get_condition, consequent_fn, alternate_fn = null, elseif = false) {
  var anchor = node;
  var consequent_effect = null;
  var alternate_effect = null;
  var condition = null;
  var flags = elseif ? EFFECT_TRANSPARENT : 0;
  block(() => {
    if (condition === (condition = !!get_condition())) return;
    if (condition) {
      if (consequent_effect) {
        resume_effect(consequent_effect);
      } else {
        consequent_effect = branch(() => consequent_fn(anchor));
      }
      if (alternate_effect) {
        pause_effect(alternate_effect, () => {
          alternate_effect = null;
        });
      }
    } else {
      if (alternate_effect) {
        resume_effect(alternate_effect);
      } else if (alternate_fn) {
        alternate_effect = branch(() => alternate_fn(anchor));
      }
      if (consequent_effect) {
        pause_effect(consequent_effect, () => {
          consequent_effect = null;
        });
      }
    }
  }, flags);
}
let current_each_item = null;
function index(_, i) {
  return i;
}
function pause_effects(state2, items, controlled_anchor, items_map) {
  var transitions = [];
  var length = items.length;
  for (var i = 0; i < length; i++) {
    pause_children(items[i].e, transitions, true);
  }
  var is_controlled = length > 0 && transitions.length === 0 && controlled_anchor !== null;
  if (is_controlled) {
    var parent_node = (
      /** @type {Element} */
      /** @type {Element} */
      controlled_anchor.parentNode
    );
    clear_text_content(parent_node);
    parent_node.append(
      /** @type {Element} */
      controlled_anchor
    );
    items_map.clear();
    link(state2, items[0].prev, items[length - 1].next);
  }
  run_out_transitions(transitions, () => {
    for (var i2 = 0; i2 < length; i2++) {
      var item = items[i2];
      if (!is_controlled) {
        items_map.delete(item.k);
        link(state2, item.prev, item.next);
      }
      destroy_effect(item.e, !is_controlled);
    }
  });
}
function each(node, flags, get_collection, get_key, render_fn, fallback_fn = null) {
  var anchor = node;
  var state2 = { flags, items: /* @__PURE__ */ new Map(), first: null };
  var is_controlled = (flags & EACH_IS_CONTROLLED) !== 0;
  if (is_controlled) {
    var parent_node = (
      /** @type {Element} */
      node
    );
    anchor = parent_node.appendChild(create_text());
  }
  var fallback = null;
  var was_empty = false;
  block(() => {
    var collection = get_collection();
    var array = is_array(collection) ? collection : collection == null ? [] : array_from(collection);
    var length = array.length;
    if (was_empty && length === 0) {
      return;
    }
    was_empty = length === 0;
    {
      var effect2 = (
        /** @type {Effect} */
        active_reaction
      );
      reconcile(array, state2, anchor, render_fn, flags, (effect2.f & INERT) !== 0, get_key);
    }
    if (fallback_fn !== null) {
      if (length === 0) {
        if (fallback) {
          resume_effect(fallback);
        } else {
          fallback = branch(() => fallback_fn(anchor));
        }
      } else if (fallback !== null) {
        pause_effect(fallback, () => {
          fallback = null;
        });
      }
    }
    get_collection();
  });
}
function reconcile(array, state2, anchor, render_fn, flags, is_inert, get_key) {
  var _a, _b, _c, _d;
  var is_animated = (flags & EACH_IS_ANIMATED) !== 0;
  var should_update = (flags & (EACH_ITEM_REACTIVE | EACH_INDEX_REACTIVE)) !== 0;
  var length = array.length;
  var items = state2.items;
  var first = state2.first;
  var current = first;
  var seen;
  var prev = null;
  var to_animate;
  var matched = [];
  var stashed = [];
  var value;
  var key;
  var item;
  var i;
  if (is_animated) {
    for (i = 0; i < length; i += 1) {
      value = array[i];
      key = get_key(value, i);
      item = items.get(key);
      if (item !== void 0) {
        (_a = item.a) == null ? void 0 : _a.measure();
        (to_animate ?? (to_animate = /* @__PURE__ */ new Set())).add(item);
      }
    }
  }
  for (i = 0; i < length; i += 1) {
    value = array[i];
    key = get_key(value, i);
    item = items.get(key);
    if (item === void 0) {
      var child_anchor = current ? (
        /** @type {TemplateNode} */
        current.e.nodes_start
      ) : anchor;
      prev = create_item(
        child_anchor,
        state2,
        prev,
        prev === null ? state2.first : prev.next,
        value,
        key,
        i,
        render_fn,
        flags
      );
      items.set(key, prev);
      matched = [];
      stashed = [];
      current = prev.next;
      continue;
    }
    if (should_update) {
      update_item(item, value, i, flags);
    }
    if ((item.e.f & INERT) !== 0) {
      resume_effect(item.e);
      if (is_animated) {
        (_b = item.a) == null ? void 0 : _b.unfix();
        (to_animate ?? (to_animate = /* @__PURE__ */ new Set())).delete(item);
      }
    }
    if (item !== current) {
      if (seen !== void 0 && seen.has(item)) {
        if (matched.length < stashed.length) {
          var start = stashed[0];
          var j;
          prev = start.prev;
          var a = matched[0];
          var b = matched[matched.length - 1];
          for (j = 0; j < matched.length; j += 1) {
            move(matched[j], start, anchor);
          }
          for (j = 0; j < stashed.length; j += 1) {
            seen.delete(stashed[j]);
          }
          link(state2, a.prev, b.next);
          link(state2, prev, a);
          link(state2, b, start);
          current = start;
          prev = b;
          i -= 1;
          matched = [];
          stashed = [];
        } else {
          seen.delete(item);
          move(item, current, anchor);
          link(state2, item.prev, item.next);
          link(state2, item, prev === null ? state2.first : prev.next);
          link(state2, prev, item);
          prev = item;
        }
        continue;
      }
      matched = [];
      stashed = [];
      while (current !== null && current.k !== key) {
        if (is_inert || (current.e.f & INERT) === 0) {
          (seen ?? (seen = /* @__PURE__ */ new Set())).add(current);
        }
        stashed.push(current);
        current = current.next;
      }
      if (current === null) {
        continue;
      }
      item = current;
    }
    matched.push(item);
    prev = item;
    current = item.next;
  }
  if (current !== null || seen !== void 0) {
    var to_destroy = seen === void 0 ? [] : array_from(seen);
    while (current !== null) {
      if (is_inert || (current.e.f & INERT) === 0) {
        to_destroy.push(current);
      }
      current = current.next;
    }
    var destroy_length = to_destroy.length;
    if (destroy_length > 0) {
      var controlled_anchor = (flags & EACH_IS_CONTROLLED) !== 0 && length === 0 ? anchor : null;
      if (is_animated) {
        for (i = 0; i < destroy_length; i += 1) {
          (_c = to_destroy[i].a) == null ? void 0 : _c.measure();
        }
        for (i = 0; i < destroy_length; i += 1) {
          (_d = to_destroy[i].a) == null ? void 0 : _d.fix();
        }
      }
      pause_effects(state2, to_destroy, controlled_anchor, items);
    }
  }
  if (is_animated) {
    queue_micro_task(() => {
      var _a2;
      if (to_animate === void 0) return;
      for (item of to_animate) {
        (_a2 = item.a) == null ? void 0 : _a2.apply();
      }
    });
  }
  active_effect.first = state2.first && state2.first.e;
  active_effect.last = prev && prev.e;
}
function update_item(item, value, index2, type) {
  if ((type & EACH_ITEM_REACTIVE) !== 0) {
    internal_set(item.v, value);
  }
  if ((type & EACH_INDEX_REACTIVE) !== 0) {
    internal_set(
      /** @type {Value<number>} */
      item.i,
      index2
    );
  } else {
    item.i = index2;
  }
}
function create_item(anchor, state2, prev, next, value, key, index2, render_fn, flags) {
  var previous_each_item = current_each_item;
  try {
    var reactive = (flags & EACH_ITEM_REACTIVE) !== 0;
    var mutable = (flags & EACH_ITEM_IMMUTABLE) === 0;
    var v = reactive ? mutable ? /* @__PURE__ */ mutable_source(value) : source(value) : value;
    var i = (flags & EACH_INDEX_REACTIVE) === 0 ? index2 : source(index2);
    var item = {
      i,
      v,
      k: key,
      a: null,
      // @ts-expect-error
      e: null,
      prev,
      next
    };
    current_each_item = item;
    item.e = branch(() => render_fn(anchor, v, i), hydrating);
    item.e.prev = prev && prev.e;
    item.e.next = next && next.e;
    if (prev === null) {
      state2.first = item;
    } else {
      prev.next = item;
      prev.e.next = item.e;
    }
    if (next !== null) {
      next.prev = item;
      next.e.prev = item.e;
    }
    return item;
  } finally {
    current_each_item = previous_each_item;
  }
}
function move(item, next, anchor) {
  var end = item.next ? (
    /** @type {TemplateNode} */
    item.next.e.nodes_start
  ) : anchor;
  var dest = next ? (
    /** @type {TemplateNode} */
    next.e.nodes_start
  ) : anchor;
  var node = (
    /** @type {TemplateNode} */
    item.e.nodes_start
  );
  while (node !== end) {
    var next_node = (
      /** @type {TemplateNode} */
      /* @__PURE__ */ get_next_sibling(node)
    );
    dest.before(node);
    node = next_node;
  }
}
function link(state2, prev, next) {
  if (prev === null) {
    state2.first = next;
  } else {
    prev.next = next;
    prev.e.next = next && next.e;
  }
  if (next !== null) {
    next.prev = prev;
    next.e.prev = prev && prev.e;
  }
}
function snippet(node, get_snippet, ...args) {
  var anchor = node;
  var snippet2 = noop;
  var snippet_effect;
  block(() => {
    if (snippet2 === (snippet2 = get_snippet())) return;
    if (snippet_effect) {
      destroy_effect(snippet_effect);
      snippet_effect = null;
    }
    snippet_effect = branch(() => (
      /** @type {SnippetFn} */
      snippet2(anchor, ...args)
    ));
  }, EFFECT_TRANSPARENT);
}
let listening_to_form_reset = false;
function add_form_reset_listener() {
  if (!listening_to_form_reset) {
    listening_to_form_reset = true;
    document.addEventListener(
      "reset",
      (evt) => {
        Promise.resolve().then(() => {
          var _a;
          if (!evt.defaultPrevented) {
            for (
              const e of
              /**@type {HTMLFormElement} */
              evt.target.elements
            ) {
              (_a = e.__on_r) == null ? void 0 : _a.call(e);
            }
          }
        });
      },
      // In the capture phase to guarantee we get noticed of it (no possiblity of stopPropagation)
      { capture: true }
    );
  }
}
function set_attribute(element, attribute, value, skip_warning) {
  var attributes = element.__attributes ?? (element.__attributes = {});
  if (attributes[attribute] === (attributes[attribute] = value)) return;
  if ("__styles" in element) {
    element.__styles = {};
  }
  if (value == null) {
    element.removeAttribute(attribute);
  } else if (typeof value !== "string" && get_setters(element).includes(attribute)) {
    element[attribute] = value;
  } else {
    element.setAttribute(attribute, value);
  }
}
var setters_cache = /* @__PURE__ */ new Map();
function get_setters(element) {
  var setters = setters_cache.get(element.nodeName);
  if (setters) return setters;
  setters_cache.set(element.nodeName, setters = []);
  var descriptors;
  var proto = get_prototype_of(element);
  var element_proto = Element.prototype;
  while (element_proto !== proto) {
    descriptors = get_descriptors(proto);
    for (var key in descriptors) {
      if (descriptors[key].set) {
        setters.push(key);
      }
    }
    proto = get_prototype_of(proto);
  }
  return setters;
}
function set_class(dom, value) {
  var prev_class_name = dom.__className;
  var next_class_name = to_class(value);
  if (prev_class_name !== next_class_name || hydrating) {
    if (value == null) {
      dom.removeAttribute("class");
    } else {
      dom.className = next_class_name;
    }
    dom.__className = next_class_name;
  }
}
function to_class(value) {
  return value == null ? "" : value;
}
function toggle_class(dom, class_name, value) {
  if (value) {
    if (dom.classList.contains(class_name)) return;
    dom.classList.add(class_name);
  } else {
    if (!dom.classList.contains(class_name)) return;
    dom.classList.remove(class_name);
  }
}
function listen_to_event_and_reset_event(element, event, handler, on_reset = handler) {
  element.addEventListener(event, handler);
  const prev = element.__on_r;
  if (prev) {
    element.__on_r = () => {
      prev();
      on_reset();
    };
  } else {
    element.__on_r = on_reset;
  }
  add_form_reset_listener();
}
function bind_value(input, get2, set2 = get2) {
  var runes = is_runes();
  listen_to_event_and_reset_event(input, "input", () => {
    var value = is_numberlike_input(input) ? to_number(input.value) : input.value;
    set2(value);
    if (runes && value !== (value = get2())) {
      input.value = value ?? "";
    }
  });
  render_effect(() => {
    var value = get2();
    if (is_numberlike_input(input) && value === to_number(input.value)) {
      return;
    }
    if (input.type === "date" && !value && !input.value) {
      return;
    }
    if (value !== input.value) {
      input.value = value ?? "";
    }
  });
}
function bind_checked(input, get2, set2 = get2) {
  listen_to_event_and_reset_event(input, "change", () => {
    var value = input.checked;
    set2(value);
  });
  if (get2() == void 0) {
    set2(false);
  }
  render_effect(() => {
    var value = get2();
    input.checked = Boolean(value);
  });
}
function is_numberlike_input(input) {
  var type = input.type;
  return type === "number" || type === "range";
}
function to_number(value) {
  return value === "" ? null : +value;
}
function select_option(select, value, mounting) {
  if (select.multiple) {
    return select_options(select, value);
  }
  for (var option of select.options) {
    var option_value = get_option_value(option);
    if (is(option_value, value)) {
      option.selected = true;
      return;
    }
  }
  if (!mounting || value !== void 0) {
    select.selectedIndex = -1;
  }
}
function init_select(select, get_value) {
  let mounting = true;
  effect(() => {
    if (get_value) {
      select_option(select, untrack(get_value), mounting);
    }
    mounting = false;
    var observer = new MutationObserver(() => {
      var value = select.__value;
      select_option(select, value);
    });
    observer.observe(select, {
      // Listen to option element changes
      childList: true,
      subtree: true,
      // because of <optgroup>
      // Listen to option element value attribute changes
      // (doesn't get notified of select value changes,
      // because that property is not reflected as an attribute)
      attributes: true,
      attributeFilter: ["value"]
    });
    return () => {
      observer.disconnect();
    };
  });
}
function bind_select_value(select, get2, set2 = get2) {
  var mounting = true;
  listen_to_event_and_reset_event(select, "change", () => {
    var value;
    if (select.multiple) {
      value = [].map.call(select.querySelectorAll(":checked"), get_option_value);
    } else {
      var selected_option = select.querySelector(":checked");
      value = selected_option && get_option_value(selected_option);
    }
    set2(value);
  });
  effect(() => {
    var value = get2();
    select_option(select, value, mounting);
    if (mounting && value === void 0) {
      var selected_option = select.querySelector(":checked");
      if (selected_option !== null) {
        value = get_option_value(selected_option);
        set2(value);
      }
    }
    select.__value = value;
    mounting = false;
  });
  init_select(select);
}
function select_options(select, value) {
  for (var option of select.options) {
    option.selected = ~value.indexOf(get_option_value(option));
  }
}
function get_option_value(option) {
  if ("__value" in option) {
    return option.__value;
  } else {
    return option.value;
  }
}
function init(immutable = false) {
  const context = (
    /** @type {ComponentContextLegacy} */
    component_context
  );
  const callbacks = context.l.u;
  if (!callbacks) return;
  let props = () => deep_read_state(context.s);
  if (immutable) {
    let version = 0;
    let prev = (
      /** @type {Record<string, any>} */
      {}
    );
    const d = /* @__PURE__ */ derived(() => {
      let changed = false;
      const props2 = context.s;
      for (const key in props2) {
        if (props2[key] !== prev[key]) {
          prev[key] = props2[key];
          changed = true;
        }
      }
      if (changed) version++;
      return version;
    });
    props = () => get(d);
  }
  if (callbacks.b.length) {
    user_pre_effect(() => {
      observe_all(context, props);
      run_all(callbacks.b);
    });
  }
  user_effect(() => {
    const fns = untrack(() => callbacks.m.map(run));
    return () => {
      for (const fn of fns) {
        if (typeof fn === "function") {
          fn();
        }
      }
    };
  });
  if (callbacks.a.length) {
    user_effect(() => {
      observe_all(context, props);
      run_all(callbacks.a);
    });
  }
}
function observe_all(context, props) {
  if (context.l.s) {
    for (const signal of context.l.s) get(signal);
  }
  props();
}
function onMount(fn) {
  if (component_context === null) {
    lifecycle_outside_component();
  }
  if (component_context.l !== null) {
    init_update_callbacks(component_context).m.push(fn);
  } else {
    user_effect(() => {
      const cleanup = untrack(fn);
      if (typeof cleanup === "function") return (
        /** @type {() => void} */
        cleanup
      );
    });
  }
}
function onDestroy(fn) {
  if (component_context === null) {
    lifecycle_outside_component();
  }
  onMount(() => () => untrack(fn));
}
function init_update_callbacks(context) {
  var l = (
    /** @type {ComponentContextLegacy} */
    context.l
  );
  return l.u ?? (l.u = { a: [], b: [], m: [] });
}
let is_store_binding = false;
function capture_store_binding(fn) {
  var previous_is_store_binding = is_store_binding;
  try {
    is_store_binding = false;
    return [fn(), is_store_binding];
  } finally {
    is_store_binding = previous_is_store_binding;
  }
}
function with_parent_branch(fn) {
  var effect2 = active_effect;
  var previous_effect = active_effect;
  while (effect2 !== null && (effect2.f & (BRANCH_EFFECT | ROOT_EFFECT)) === 0) {
    effect2 = effect2.parent;
  }
  try {
    set_active_effect(effect2);
    return fn();
  } finally {
    set_active_effect(previous_effect);
  }
}
function prop(props, key, flags, fallback) {
  var _a;
  var immutable = (flags & PROPS_IS_IMMUTABLE) !== 0;
  var runes = (flags & PROPS_IS_RUNES) !== 0;
  var bindable = (flags & PROPS_IS_BINDABLE) !== 0;
  var lazy = (flags & PROPS_IS_LAZY_INITIAL) !== 0;
  var is_store_sub = false;
  var prop_value;
  if (bindable) {
    [prop_value, is_store_sub] = capture_store_binding(() => (
      /** @type {V} */
      props[key]
    ));
  } else {
    prop_value = /** @type {V} */
    props[key];
  }
  var setter = (_a = get_descriptor(props, key)) == null ? void 0 : _a.set;
  var fallback_value = (
    /** @type {V} */
    fallback
  );
  var fallback_dirty = true;
  var fallback_used = false;
  var get_fallback = () => {
    fallback_used = true;
    if (fallback_dirty) {
      fallback_dirty = false;
      if (lazy) {
        fallback_value = untrack(
          /** @type {() => V} */
          fallback
        );
      } else {
        fallback_value = /** @type {V} */
        fallback;
      }
    }
    return fallback_value;
  };
  if (prop_value === void 0 && fallback !== void 0) {
    if (setter && runes) {
      props_invalid_value();
    }
    prop_value = get_fallback();
    if (setter) setter(prop_value);
  }
  var getter;
  if (runes) {
    getter = () => {
      var value = (
        /** @type {V} */
        props[key]
      );
      if (value === void 0) return get_fallback();
      fallback_dirty = true;
      fallback_used = false;
      return value;
    };
  } else {
    var derived_getter = with_parent_branch(
      () => (immutable ? derived : derived_safe_equal)(() => (
        /** @type {V} */
        props[key]
      ))
    );
    derived_getter.f |= LEGACY_DERIVED_PROP;
    getter = () => {
      var value = get(derived_getter);
      if (value !== void 0) fallback_value = /** @type {V} */
      void 0;
      return value === void 0 ? fallback_value : value;
    };
  }
  if ((flags & PROPS_IS_UPDATED) === 0) {
    return getter;
  }
  if (setter) {
    var legacy_parent = props.$$legacy;
    return function(value, mutation) {
      if (arguments.length > 0) {
        if (!runes || !mutation || legacy_parent || is_store_sub) {
          setter(mutation ? getter() : value);
        }
        return value;
      } else {
        return getter();
      }
    };
  }
  var from_child = false;
  var was_from_child = false;
  var inner_current_value = /* @__PURE__ */ mutable_source(prop_value);
  var current_value = with_parent_branch(
    () => /* @__PURE__ */ derived(() => {
      var parent_value = getter();
      var child_value = get(inner_current_value);
      if (from_child) {
        from_child = false;
        was_from_child = true;
        return child_value;
      }
      was_from_child = false;
      return inner_current_value.v = parent_value;
    })
  );
  if (!immutable) current_value.equals = safe_equals;
  return function(value, mutation) {
    if (arguments.length > 0) {
      const new_value = mutation ? get(current_value) : runes && bindable ? proxy(value) : value;
      if (!current_value.equals(new_value)) {
        from_child = true;
        set(inner_current_value, new_value);
        if (fallback_used && fallback_value !== void 0) {
          fallback_value = new_value;
        }
        untrack(() => get(current_value));
      }
      return value;
    }
    return get(current_value);
  };
}
const themes = {
  dark: {
    primary: "#89b4fa",
    secondary: "#cba6f7",
    color1: "#f5c2e7",
    color2: "#a6e3a1",
    color3: "#fab387",
    color4: "#f38ba8",
    background: "#1e1e2e",
    background2: "#313244",
    text: "#cdd6f4",
    text2: "#a6adc8"
  },
  light: {
    primary: "#7287fd",
    secondary: "#8839ef",
    color1: "#ea76cb",
    color2: "#40a02b",
    color3: "#fe640b",
    color4: "#d20f39",
    background: "#eff1f5",
    background2: "#ccd0da",
    text: "#4c4f69",
    text2: "#6c6f85"
  }
};
function setTheme(theme) {
  document.documentElement.style.setProperty("--primary-color", theme.primary);
  document.documentElement.style.setProperty("--secondary-color", theme.secondary);
  document.documentElement.style.setProperty("--color1", theme.color1);
  document.documentElement.style.setProperty("--color2", theme.color2);
  document.documentElement.style.setProperty("--color3", theme.color3);
  document.documentElement.style.setProperty("--color4", theme.color4);
  document.documentElement.style.setProperty("--background-color", theme.background);
  document.documentElement.style.setProperty("--text-color", theme.text);
  document.documentElement.style.setProperty("--text2-color", theme.text2);
  document.documentElement.style.setProperty("--background2-color", theme.background2);
  document.documentElement.style.setProperty("--primary-color-transparent", `${theme.primary}33`);
  document.documentElement.style.setProperty("--background-color-transparent", `${theme.background}dd`);
}
class Config {
  constructor() {
    __publicField(this, "IS_BROWSER", !window.invokeNative);
    __publicField(this, "RESOURCE_NAME", window.GetParentResourceName ? window.GetParentResourceName() : "svelte_template");
    __publicField(this, "ESC_TO_EXIT", true);
    __privateAdd(this, _theme, state(proxy(localStorage.getItem("theme") || "dark")));
    this.setTheme(this.theme);
  }
  get theme() {
    return get(__privateGet(this, _theme));
  }
  set theme(value) {
    set(__privateGet(this, _theme), proxy(value));
  }
  setTheme(theme) {
    const selectedTheme = themes[theme];
    if (!selectedTheme) return;
    setTheme(selectedTheme);
    this.theme = theme;
    localStorage.setItem("theme", theme);
  }
}
_theme = new WeakMap();
const CONFIG = new Config();
var Tabs = /* @__PURE__ */ ((Tabs2) => {
  Tabs2["HOME"] = "Home";
  Tabs2["ENTITY"] = "Entity";
  Tabs2["SETTINGS"] = "Settings";
  return Tabs2;
})(Tabs || {});
function handleChange(event, value, onChange) {
  const target = event.target;
  value(target.value);
  onChange()(target.value);
}
var root_1$4 = /* @__PURE__ */ template(`<label class="dropdown-label svelte-137ukv4" for="dropdown"> </label>`);
var root_2$1 = /* @__PURE__ */ template(`<option class="svelte-137ukv4"> </option>`);
var root$7 = /* @__PURE__ */ template(`<div class="dropdown-container svelte-137ukv4"><!> <select id="dropdown" class="dropdown svelte-137ukv4"></select></div>`);
function DropDown($$anchor, $$props) {
  push($$props, true);
  let value = prop($$props, "value", 15, ""), options = prop($$props, "options", 19, () => []), label = prop($$props, "label", 3, ""), width = prop($$props, "width", 3, "100%"), style = prop($$props, "style", 3, ""), onChange = prop($$props, "onChange", 3, () => {
  });
  var div = root$7();
  var node = child(div);
  if_block(node, label, ($$anchor2) => {
    var label_1 = root_1$4();
    var text2 = child(label_1);
    template_effect(() => set_text(text2, label()));
    append($$anchor2, label_1);
  });
  var select = sibling(node, 2);
  init_select(select, value);
  var select_value;
  select.__change = [handleChange, value, onChange];
  each(select, 21, options, index, ($$anchor2, option) => {
    var option_1 = root_2$1();
    var option_1_value = {};
    var text_1 = child(option_1);
    template_effect(() => {
      if (option_1_value !== (option_1_value = get(option).value)) {
        option_1.value = null == (option_1.__value = get(option).value) ? "" : get(option).value;
      }
      set_text(text_1, get(option).label);
    });
    append($$anchor2, option_1);
  });
  template_effect(() => {
    set_attribute(div, "style", style());
    if (select_value !== (select_value = value())) {
      select.value = null == (select.__value = value()) ? "" : value(), select_option(select, value());
    }
    set_attribute(select, "style", `width: ${width() ?? ""}`);
  });
  append($$anchor, div);
  pop();
}
delegate(["change"]);
var root$6 = /* @__PURE__ */ template(`<nav class="svelte-5icivy"><!></nav>`);
function Navigation($$anchor, $$props) {
  push($$props, true);
  let activeTab = prop($$props, "activeTab", 31, () => proxy(Tabs.HOME)), isSticky = prop($$props, "isSticky", 3, true);
  let tabs = Object.values(Tabs);
  var nav = root$6();
  var node = child(nav);
  var options = /* @__PURE__ */ derived(() => tabs.map((tab) => ({ value: tab, label: tab })));
  DropDown(node, {
    get value() {
      return activeTab();
    },
    get options() {
      return get(options);
    },
    onChange: (value) => activeTab(value),
    style: "padding: 8px;"
  });
  template_effect(() => set_attribute(nav, "style", isSticky() ? "position: sticky; top: 0; z-index: 1000;" : ""));
  append($$anchor, nav);
  pop();
}
var root$5 = /* @__PURE__ */ template(`<div class="settings-container svelte-ilwuy3"><div class="setting-row svelte-ilwuy3"><span class="setting-label svelte-ilwuy3">Theme</span> <!></div></div>`);
function Settings($$anchor, $$props) {
  push($$props, false);
  init();
  var div = root$5();
  var div_1 = child(div);
  var node = sibling(child(div_1), 2);
  var options = /* @__PURE__ */ derived_safe_equal(() => Object.keys(themes).map((theme) => ({
    value: theme,
    label: theme.charAt(0).toUpperCase() + theme.slice(1)
  })));
  DropDown(node, {
    get value() {
      return CONFIG.theme;
    },
    get options() {
      return get(options);
    },
    onChange: (value) => CONFIG.setTheme(value),
    style: "width: 80%;"
  });
  append($$anchor, div);
  pop();
}
const debugEventListeners = {};
async function FetchNUI(eventName, data) {
  if (CONFIG.IS_BROWSER) {
    const debugReturn = await DebugNUICallback(eventName, data);
    return debugReturn;
  }
  const options = {
    method: "post",
    headers: {
      "Content-Type": "application/json; charset=UTF-8"
    },
    body: JSON.stringify(data)
  };
  const resp = await fetch(
    `https://${CONFIG.RESOURCE_NAME}/${eventName}`,
    options
  );
  return await resp.json();
}
function SendNUI(eventName, data) {
  if (CONFIG.IS_BROWSER) {
    DebugNUICallback(eventName, data);
    return;
  }
  const options = {
    method: "post",
    headers: {
      "Content-Type": "application/json; charset=UTF-8"
    },
    body: JSON.stringify(data)
  };
  fetch(`https://${CONFIG.RESOURCE_NAME}/${eventName}`, options);
}
function ReceiveNUI(action, handler) {
  const eventListener = (event) => {
    const { action: eventAction, data } = event.data;
    eventAction === action && handler(data);
  };
  onMount(() => window.addEventListener("message", eventListener));
  onDestroy(() => window.removeEventListener("message", eventListener));
}
async function SendDebugNUI(event, timer = 0) {
  if (!CONFIG.IS_BROWSER) return;
  setTimeout(() => {
    window.dispatchEvent(
      new MessageEvent("message", {
        data: {
          action: event.action,
          data: event.data
        }
      })
    );
  }, timer);
}
async function ReceiveDebugNUI(action, handler) {
  if (!CONFIG.IS_BROWSER) return;
  console.log(`[DEBUG] Adding debug receiver for ${action} event.`);
  if (debugEventListeners[action] !== void 0) {
    console.log(
      `%c[DEBUG] %c${action} %cevent already has a debug receiver.`,
      "color: red; font-weight: bold;",
      "color: green",
      ""
    );
    return debugEventListeners[action];
  }
  debugEventListeners[action] = (data) => {
    console.log(
      `%c[DEBUG]%c Received %c${action} %cevent with data:${data}`,
      "color: green;",
      "color: white;",
      "color: yellow;",
      "color: white;"
    );
    return handler ? handler(data) : {};
  };
}
async function DebugNUICallback(action, data) {
  if (!CONFIG.IS_BROWSER) {
    return {};
  }
  const handler = debugEventListeners[action];
  if (handler === void 0) {
    console.warn(
      `%c[DEBUG] %c${action} event does not have a debugger.`,
      "color: red; font-weight: bold;",
      "color: green;"
    );
    return {};
  }
  const new_handler = (data2) => {
    console.log(
      `%c[DEBUG] %cCalling handler for %c${action}`,
      "color: green;",
      "color: white;",
      "color: yellow;"
    );
    return handler(data2);
  };
  const result = await new_handler(data);
  return result;
}
var root$4 = /* @__PURE__ */ template(`<button><!></button>`);
function Button($$anchor, $$props) {
  push($$props, true);
  const fullWidth = prop($$props, "fullWidth", 3, false), disabled = prop($$props, "disabled", 3, false), selected = prop($$props, "selected", 3, false), onClick = prop($$props, "onClick", 3, () => {
  });
  var button = root$4();
  button.__click = function(...$$args) {
    var _a;
    (_a = onClick()) == null ? void 0 : _a.apply(this, $$args);
  };
  var node = child(button);
  snippet(node, () => $$props.children);
  template_effect(() => {
    set_class(button, `${`btn ${fullWidth() ? "full-width" : ""} ${selected() ? "selected" : ""}` ?? ""} svelte-svapgx`);
    button.disabled = disabled();
  });
  append($$anchor, button);
  pop();
}
delegate(["click"]);
function toggle(_, collapsed) {
  set(collapsed, !get(collapsed));
}
var root_1$3 = /* @__PURE__ */ template(`<span class="count-badge svelte-nwyfvx"> </span>`);
var root$3 = /* @__PURE__ */ template(`<div><button class="collapsible-header svelte-nwyfvx" type="button"><div class="header-left svelte-nwyfvx"><span class="collapse-icon svelte-nwyfvx"><svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><polyline points="6,9 12,15 18,9"></polyline></svg></span> <span class="title svelte-nwyfvx"> </span> <!></div> <div class="header-right svelte-nwyfvx"><!></div></button> <div class="collapsible-content svelte-nwyfvx"><div class="content-inner svelte-nwyfvx"><!></div></div></div>`);
function CollapsibleBox($$anchor, $$props) {
  push($$props, true);
  let isOpen = prop($$props, "isOpen", 3, true), variant = prop($$props, "variant", 3, "default"), size = prop($$props, "size", 3, "md");
  let collapsed = state(!isOpen());
  const variantClasses = {
    default: "collapsible-default",
    primary: "collapsible-primary",
    success: "collapsible-success",
    warning: "collapsible-warning",
    danger: "collapsible-danger"
  };
  const sizeClasses = {
    sm: "collapsible-sm",
    md: "collapsible-md",
    lg: "collapsible-lg"
  };
  var div = root$3();
  var button = child(div);
  button.__click = [toggle, collapsed];
  var div_1 = child(button);
  var span = child(div_1);
  var span_1 = sibling(span, 2);
  var text2 = child(span_1);
  var node = sibling(span_1, 2);
  if_block(node, () => $$props.showCount !== void 0, ($$anchor2) => {
    var span_2 = root_1$3();
    var text_1 = child(span_2);
    template_effect(() => set_text(text_1, $$props.showCount));
    append($$anchor2, span_2);
  });
  var div_2 = sibling(div_1, 2);
  var node_1 = child(div_2);
  if_block(node_1, () => $$props.headerContent, ($$anchor2) => {
    var fragment = comment();
    var node_2 = first_child(fragment);
    snippet(node_2, () => $$props.headerContent);
    append($$anchor2, fragment);
  });
  var div_3 = sibling(button, 2);
  var div_4 = child(div_3);
  var node_3 = child(div_4);
  snippet(node_3, () => $$props.children);
  template_effect(() => {
    set_class(div, `collapsible-box ${variantClasses[variant()] ?? ""} ${sizeClasses[size()] ?? ""} svelte-nwyfvx`);
    toggle_class(span, "collapsed", get(collapsed));
    set_text(text2, $$props.title);
    toggle_class(div_3, "collapsed", get(collapsed));
  });
  append($$anchor, div);
  pop();
}
delegate(["click"]);
class Providers {
  constructor() {
    __privateAdd(this, _isVisible, state(false));
    __privateAdd(this, _cameraActive, state(false));
  }
  get isVisible() {
    return get(__privateGet(this, _isVisible));
  }
  set isVisible(value) {
    set(__privateGet(this, _isVisible), proxy(value));
  }
  get cameraActive() {
    return get(__privateGet(this, _cameraActive));
  }
  set cameraActive(value) {
    set(__privateGet(this, _cameraActive), proxy(value));
  }
}
_isVisible = new WeakMap();
_cameraActive = new WeakMap();
const providers = new Providers();
var on_click$1 = (e) => e.stopPropagation();
var root_2 = /* @__PURE__ */ template(`<div class="camera-loading svelte-6lh06a"><div class="loading-spinner svelte-6lh06a"></div> <p class="svelte-6lh06a">Activating camera view...</p> <p class="loading-hint svelte-6lh06a">Camera will take over your screen</p></div>`);
var on_click_1 = (_, openCamera) => openCamera();
var root_4$1 = /* @__PURE__ */ template(`<div class="camera-error svelte-6lh06a"><div class="error-icon svelte-6lh06a">⚠️</div> <p class="svelte-6lh06a"> </p> <button class="retry-button svelte-6lh06a">Retry</button></div>`);
var root_5$1 = /* @__PURE__ */ template(`<p class="svelte-6lh06a">something went wrong</p>`);
var root_1$2 = /* @__PURE__ */ template(`<div class="camera-overlay svelte-6lh06a"><div class="camera-container svelte-6lh06a"><div class="camera-header svelte-6lh06a"><div class="camera-title svelte-6lh06a"><span class="camera-icon svelte-6lh06a">📹</span> Entity Camera View</div> <button class="close-button svelte-6lh06a" type="button"><svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" class="svelte-6lh06a"><line x1="18" y1="6" x2="6" y2="18" class="svelte-6lh06a"></line><line x1="6" y1="6" x2="18" y2="18" class="svelte-6lh06a"></line></svg></button></div> <div class="camera-content svelte-6lh06a"><!></div></div></div>`);
var root_7 = /* @__PURE__ */ template(`<div class="camera-escape-overlay svelte-6lh06a"><div class="escape-panel svelte-6lh06a"><div class="escape-header svelte-6lh06a"><span class="camera-icon svelte-6lh06a">📹</span> <span class="escape-title svelte-6lh06a">Camera Mode</span></div> <div class="escape-controls svelte-6lh06a"><div class="control-section svelte-6lh06a"><div class="control-title svelte-6lh06a">Camera Movement</div> <div class="control-grid svelte-6lh06a"><div class="control-row svelte-6lh06a"><span class="control-keys svelte-6lh06a"><span class="key svelte-6lh06a">W</span> <span class="key svelte-6lh06a">A</span> <span class="key svelte-6lh06a">S</span> <span class="key svelte-6lh06a">D</span> <span class="key svelte-6lh06a">Mouse</span></span> <span class="control-desc svelte-6lh06a">Move Camera</span></div> <div class="control-row svelte-6lh06a"><span class="control-keys svelte-6lh06a"><span class="key svelte-6lh06a">Q</span> <span class="key svelte-6lh06a">E</span></span> <span class="control-desc svelte-6lh06a">Up/Down</span></div></div></div> <div class="control-section svelte-6lh06a"><div class="control-title svelte-6lh06a">Exit Camera</div> <div class="escape-options svelte-6lh06a"><button class="escape-button svelte-6lh06a"><span class="key svelte-6lh06a">ESC</span> <span class="svelte-6lh06a">or Click Here</span></button></div></div></div> <div class="entity-info svelte-6lh06a"><div class="info-row svelte-6lh06a"><span class="info-label svelte-6lh06a">Entity:</span> <span class="info-value svelte-6lh06a"> </span></div> <div class="info-row svelte-6lh06a"><span class="info-label svelte-6lh06a">Coords:</span> <span class="info-value svelte-6lh06a"> </span></div> <div class="info-row svelte-6lh06a"><span class="info-label svelte-6lh06a">Group:</span> <span class="info-value svelte-6lh06a"> </span></div></div></div></div>`);
function EntityCamera($$anchor, $$props) {
  push($$props, true);
  let groupEntities = prop($$props, "groupEntities", 19, () => []);
  let isLoading = state(false);
  let error = state(null);
  async function openCamera() {
    if (!$$props.isOpen) return;
    set(isLoading, true);
    set(error, null);
    const entityIdStr = String($$props.entityId);
    const id = parseInt(entityIdStr.split("(")[0]);
    if (isNaN(id)) {
      set(error, "Invalid entity ID format");
      set(isLoading, false);
      return;
    }
    try {
      const response = await FetchNUI("createEntityCamera", {
        entityId: id,
        coords: $$props.coords,
        groupEntities: groupEntities()
      });
      console.log("Camera response:", response);
      if (response.err || !response.result) {
        set(error, proxy(response.err || "Failed to create camera"));
      } else {
        providers.cameraActive = true;
      }
    } catch (err) {
      set(error, "Failed to create camera view");
      console.error("Camera error:", err);
    } finally {
      set(isLoading, false);
    }
  }
  async function closeCamera() {
    try {
      await FetchNUI("closeEntityCamera", {});
      providers.cameraActive = false;
    } catch (err) {
      console.error("Error closing camera:", err);
    }
    $$props.onClose();
  }
  ReceiveNUI("closeEntityCamera", () => {
    providers.cameraActive = false;
    $$props.onClose();
  });
  user_effect(() => {
    if ($$props.isOpen) {
      openCamera();
    } else {
      closeCamera();
    }
  });
  var fragment = comment();
  var node = first_child(fragment);
  if_block(
    node,
    () => $$props.isOpen && !providers.cameraActive,
    ($$anchor2) => {
      var div = root_1$2();
      div.__click = closeCamera;
      var div_1 = child(div);
      div_1.__click = [on_click$1];
      var div_2 = child(div_1);
      var button = sibling(child(div_2), 2);
      button.__click = closeCamera;
      var div_3 = sibling(div_2, 2);
      var node_1 = child(div_3);
      if_block(
        node_1,
        () => get(isLoading),
        ($$anchor3) => {
          var div_4 = root_2();
          append($$anchor3, div_4);
        },
        ($$anchor3) => {
          var fragment_1 = comment();
          var node_2 = first_child(fragment_1);
          if_block(
            node_2,
            () => get(error),
            ($$anchor4) => {
              var div_5 = root_4$1();
              var p = sibling(child(div_5), 2);
              var text2 = child(p);
              var button_1 = sibling(p, 2);
              button_1.__click = [on_click_1, openCamera];
              template_effect(() => set_text(text2, get(error)));
              append($$anchor4, div_5);
            },
            ($$anchor4) => {
              var p_1 = root_5$1();
              append($$anchor4, p_1);
            },
            true
          );
          append($$anchor3, fragment_1);
        }
      );
      append($$anchor2, div);
    },
    ($$anchor2) => {
      var fragment_2 = comment();
      var node_3 = first_child(fragment_2);
      if_block(
        node_3,
        () => providers.cameraActive,
        ($$anchor3) => {
          var div_6 = root_7();
          var div_7 = child(div_6);
          var div_8 = sibling(child(div_7), 2);
          var div_9 = sibling(child(div_8), 2);
          var div_10 = sibling(child(div_9), 2);
          var button_2 = child(div_10);
          button_2.__click = closeCamera;
          var div_11 = sibling(div_8, 2);
          var div_12 = child(div_11);
          var span = sibling(child(div_12), 2);
          var text_1 = child(span);
          var div_13 = sibling(div_12, 2);
          var span_1 = sibling(child(div_13), 2);
          const stringified_text = /* @__PURE__ */ derived(() => $$props.coords.x.toFixed(1) ?? "");
          const stringified_text_1 = /* @__PURE__ */ derived(() => $$props.coords.y.toFixed(1) ?? "");
          const stringified_text_2 = /* @__PURE__ */ derived(() => $$props.coords.z.toFixed(1) ?? "");
          var text_2 = child(span_1);
          template_effect(() => set_text(text_2, `${get(stringified_text)}, ${get(stringified_text_1)}, ${get(stringified_text_2)}`));
          var div_14 = sibling(div_13, 2);
          var span_2 = sibling(child(div_14), 2);
          var text_3 = child(span_2);
          template_effect(() => {
            set_text(text_1, $$props.entityId);
            set_text(text_3, `${groupEntities().length ?? ""} entities highlighted`);
          });
          append($$anchor3, div_6);
        },
        null,
        true
      );
      append($$anchor2, fragment_2);
    }
  );
  append($$anchor, fragment);
  pop();
}
delegate(["click"]);
var root_1$1 = /* @__PURE__ */ template(`<div class="control-group svelte-158xaox"><label for="max-distance" class="svelte-158xaox">Group Dist:</label> <input id="max-distance" type="number" min="0.1" step="0.1" class="svelte-158xaox"></div>`);
var root_3 = /* @__PURE__ */ template(`<option> </option>`);
var root_4 = /* @__PURE__ */ template(`<div class="control-group svelte-158xaox"><label for="max-player-distance" class="svelte-158xaox">Max:</label> <input id="max-player-distance" type="number" min="1" step="1" class="svelte-158xaox"></div>`);
var root_5 = /* @__PURE__ */ template(`<p class="no-groups svelte-158xaox">No entity groups found with current settings.</p>`);
var root_10 = /* @__PURE__ */ template(`<div class="entity-script svelte-158xaox"><span class="script-label svelte-158xaox">Script:</span> <span class="script-name svelte-158xaox"> </span></div>`);
var on_click = (_, openEntityCamera, entity, group) => openEntityCamera(get(entity), group());
var root_9 = /* @__PURE__ */ template(`<div class="entity-card svelte-158xaox"><div class="entity-header svelte-158xaox"><div class="entity-type-badge svelte-158xaox"> </div> <div class="entity-id svelte-158xaox"> </div></div> <div class="entity-content svelte-158xaox"><div class="entity-model svelte-158xaox"> </div> <div class="entity-position svelte-158xaox"><span class="coord-label svelte-158xaox">Pos:</span> <span class="coords svelte-158xaox"> </span></div> <!></div> <div class="entity-footer svelte-158xaox"><div class="entity-actions svelte-158xaox"><button class="camera-button svelte-158xaox" title="View Camera &amp; Highlight Group">📹</button> <div class="entity-number svelte-158xaox"></div></div> <div class="entity-network svelte-158xaox"> </div></div></div>`);
var root_8 = /* @__PURE__ */ template(`<div class="entity-grid svelte-158xaox"></div>`);
var root_11 = /* @__PURE__ */ template(`<div class="group-stats svelte-158xaox"><span class="stat-item svelte-158xaox"> </span> <span class="stat-item svelte-158xaox"> </span></div>`);
var root_6 = /* @__PURE__ */ template(`<div class="summary svelte-158xaox"><div class="summary-item svelte-158xaox"><span class="summary-value svelte-158xaox"> </span> <span class="summary-label svelte-158xaox">Groups Found</span></div> <div class="summary-item svelte-158xaox"><span class="summary-value svelte-158xaox"> </span> <span class="summary-label svelte-158xaox">Filtered Entities</span></div> <div class="summary-item svelte-158xaox"><span class="summary-value svelte-158xaox"> </span> <span class="summary-label svelte-158xaox">Total Found</span></div> <div class="summary-item svelte-158xaox"><span class="summary-value svelte-158xaox"> </span> <span class="summary-label svelte-158xaox">Filtered Net</span></div></div> <!>`, 1);
var root$2 = /* @__PURE__ */ template(`<div id="entity-checker-container" class="svelte-158xaox"><div class="controls svelte-158xaox"><div class="control-section svelte-158xaox"><h3 class="section-title svelte-158xaox">Grouping & Detection</h3> <div class="control-row svelte-158xaox"><div class="control-group svelte-158xaox"><label for="grouping-mode" class="svelte-158xaox">Grouping:</label> <select id="grouping-mode" class="svelte-158xaox"><option>Distance</option><option>Model</option><option>Model + Distance</option></select></div> <!> <div class="control-group svelte-158xaox"><label for="networked-only" class="svelte-158xaox">Net Only:</label> <input id="networked-only" type="checkbox" class="svelte-158xaox"></div> <div class="control-group action-group svelte-158xaox"><!></div></div></div> <div class="control-section svelte-158xaox"><h3 class="section-title svelte-158xaox">Filters & Sorting</h3> <div class="control-row svelte-158xaox"><div class="control-group svelte-158xaox"><label for="entity-filter" class="svelte-158xaox">Entity/Model:</label> <input id="entity-filter" type="text" placeholder="Filter by name/model..." class="svelte-158xaox"></div> <div class="control-group svelte-158xaox"><label for="script-filter" class="svelte-158xaox">Script:</label> <select id="script-filter" class="svelte-158xaox"><option>All</option><option>None</option><!></select></div> <div class="control-group svelte-158xaox"><label for="player-distance-enabled" class="svelte-158xaox">Player Dist:</label> <input id="player-distance-enabled" type="checkbox" class="svelte-158xaox"></div> <!> <div class="control-group svelte-158xaox"><label for="sort-by" class="svelte-158xaox">Sort:</label> <select id="sort-by" class="svelte-158xaox"><option>Count</option><option>Distance</option></select></div></div></div></div> <div class="results svelte-158xaox"><!></div> <!></div>`);
function EntityChecker($$anchor, $$props) {
  push($$props, true);
  let entities = state(proxy([]));
  let groupingMode = state("model-distance");
  let maxDistance = state(5);
  let networked_only = state(false);
  let allGroups = state(proxy({}));
  let scriptFilter = state("all");
  let sortBy = state("count");
  let entityFilter = state("");
  let maxPlayerDistance = state(100);
  let enablePlayerDistanceFilter = state(false);
  let cameraEntity = state(null);
  let cameraGroup = state(proxy([]));
  let showCamera = state(false);
  let playerPosition = state(proxy({ x: 0, y: 0, z: 0 }));
  const groupedEntities = /* @__PURE__ */ derived(() => {
    console.log("groupedEntities recalculating, sortBy:", get(sortBy), "allGroups length:", Object.keys(get(allGroups)).length);
    if (Object.keys(get(allGroups)).length === 0) return {};
    const filtered = {};
    for (const [groupName, group] of Object.entries(get(allGroups))) {
      const filteredGroup = filterGroup(group);
      if (filteredGroup.length > 0) {
        filtered[groupName] = filteredGroup;
      }
    }
    console.log("Before sorting:", Object.keys(filtered));
    const sorted = sortGroups(filtered);
    console.log("After sorting:", Object.keys(sorted));
    return sorted;
  });
  const uniqueScripts = /* @__PURE__ */ derived(() => {
    const allGroupedEntities = Object.values(get(allGroups)).flat();
    const scripts = [
      ...new Set(allGroupedEntities.map((e) => e.script).filter(Boolean))
    ];
    return scripts.sort();
  });
  user_effect(() => {
    if (get(entities).length > 0) {
      buildGroups();
    }
  });
  function calculateDistance(pos1, pos2) {
    const dx = pos1.x - pos2.x;
    const dy = pos1.y - pos2.y;
    const dz = pos1.z - pos2.z;
    return Math.sqrt(dx * dx + dy * dy + dz * dz);
  }
  function groupEntitiesByDistance(entities2, maxDist) {
    const groups = {};
    const processed = /* @__PURE__ */ new Set();
    for (const entity of entities2) {
      if (processed.has(entity.id)) continue;
      const group = [entity];
      processed.add(entity.id);
      for (const otherEntity of entities2) {
        if (processed.has(otherEntity.id)) continue;
        const isNearGroup = group.some((groupEntity) => calculateDistance(groupEntity.position, otherEntity.position) <= maxDist);
        if (isNearGroup) {
          group.push(otherEntity);
          processed.add(otherEntity.id);
        }
      }
      if (group.length > 1) {
        groups[`${group.length} entities`] = group;
      }
    }
    return groups;
  }
  function groupEntitiesByModel(entities2) {
    const groups = {};
    for (const entity of entities2) {
      if (!groups[entity.model]) {
        groups[entity.model] = [];
      }
      groups[entity.model].push(entity);
    }
    return groups;
  }
  function groupEntitiesByModelAndDistance(entities2, maxDist) {
    const groups = {};
    const modelGroups = {};
    for (const entity of entities2) {
      if (!modelGroups[entity.model]) {
        modelGroups[entity.model] = [];
      }
      modelGroups[entity.model].push(entity);
    }
    for (const [model, modelEntities] of Object.entries(modelGroups)) {
      if (modelEntities.length === 1) {
        groups[model] = modelEntities;
      } else {
        const distanceGroups = groupEntitiesByDistance(modelEntities, maxDist);
        if (Object.keys(distanceGroups).length === 0) {
          groups[model] = modelEntities;
        } else {
          for (const [distanceGroupName, group] of Object.entries(distanceGroups)) {
            groups[`${model} (${group.length} entities)`] = group;
          }
        }
      }
    }
    return groups;
  }
  function filterGroupByScript(group) {
    if (get(scriptFilter) === "all") return group;
    if (get(scriptFilter) === "none") return group.filter((e) => !e.script);
    return group.filter((e) => e.script === get(scriptFilter));
  }
  function filterByEntity(group) {
    if (!get(entityFilter).trim()) return group;
    const filter = get(entityFilter);
    return group.filter((e) => e.model.includes(filter) || e.id.includes(filter));
  }
  function filterByPlayerDistance(group) {
    if (!get(enablePlayerDistanceFilter) || !get(playerPosition)) return group;
    return group.filter((e) => calculateDistance(get(playerPosition), e.position) <= get(maxPlayerDistance));
  }
  function filterGroup(group) {
    let filtered = filterGroupByScript(group);
    filtered = filterByEntity(filtered);
    filtered = filterByPlayerDistance(filtered);
    return filtered;
  }
  function sortGroups(groups) {
    const entries = Object.entries(groups);
    console.log("sortGroups called with sortBy:", get(sortBy), "entries:", entries.length);
    if (get(sortBy) === "count") {
      console.log("Sorting by count");
      entries.sort(([, a], [, b]) => {
        console.log(`Comparing ${a.length} vs ${b.length}`);
        return b.length - a.length;
      });
    } else if (get(sortBy) === "distance" && get(playerPosition)) {
      console.log("Sorting by distance with playerPosition:", get(playerPosition));
      entries.sort(([, a], [, b]) => {
        const avgDistA = a.reduce(
          (sum, entity) => {
            return sum + calculateDistance(get(playerPosition), entity.position);
          },
          0
        ) / a.length;
        const avgDistB = b.reduce(
          (sum, entity) => {
            return sum + calculateDistance(get(playerPosition), entity.position);
          },
          0
        ) / b.length;
        return avgDistA - avgDistB;
      });
    } else {
      console.log("No sorting applied - sortBy:", get(sortBy), "playerPosition:", !!get(playerPosition));
    }
    return Object.fromEntries(entries);
  }
  function buildGroups() {
    let groups = {};
    switch (get(groupingMode)) {
      case "distance":
        groups = groupEntitiesByDistance(get(entities), get(maxDistance));
        break;
      case "model":
        groups = groupEntitiesByModel(get(entities));
        break;
      case "model-distance":
        groups = groupEntitiesByModelAndDistance(get(entities), get(maxDistance));
        break;
    }
    set(allGroups, proxy(groups));
  }
  async function checkEntity() {
    FetchNUI("getEntities", { networked_only: get(networked_only) }).then((res) => {
      if (res.err) throw new Error(res.err);
      set(entities, proxy(res.result.entities));
      set(playerPosition, proxy(res.result.playerPosition));
    }).catch((error) => {
      console.error("Error fetching entities:", error);
    });
  }
  function openEntityCamera(entity, group) {
    set(cameraEntity, proxy(entity));
    set(cameraGroup, proxy(group));
    set(showCamera, true);
  }
  function closeCameraView() {
    set(showCamera, false);
    set(cameraEntity, null);
    set(cameraGroup, proxy([]));
  }
  var div = root$2();
  var div_1 = child(div);
  var div_2 = child(div_1);
  var div_3 = sibling(child(div_2), 2);
  var div_4 = child(div_3);
  var select = sibling(child(div_4), 2);
  var option = child(select);
  option.value = null == (option.__value = "distance") ? "" : "distance";
  var option_1 = sibling(option);
  option_1.value = null == (option_1.__value = "model") ? "" : "model";
  var option_2 = sibling(option_1);
  option_2.value = null == (option_2.__value = "model-distance") ? "" : "model-distance";
  var node = sibling(div_4, 2);
  if_block(node, () => get(groupingMode) === "distance" || get(groupingMode) === "model-distance", ($$anchor2) => {
    var div_5 = root_1$1();
    var input = sibling(child(div_5), 2);
    bind_value(input, () => get(maxDistance), ($$value) => set(maxDistance, $$value));
    append($$anchor2, div_5);
  });
  var div_6 = sibling(node, 2);
  var input_1 = sibling(child(div_6), 2);
  var div_7 = sibling(div_6, 2);
  var node_1 = child(div_7);
  Button(node_1, {
    fullWidth: true,
    onClick: () => checkEntity(),
    children: ($$anchor2, $$slotProps) => {
      var text$1 = text("Check Entities");
      append($$anchor2, text$1);
    },
    $$slots: { default: true }
  });
  var div_8 = sibling(div_2, 2);
  var div_9 = sibling(child(div_8), 2);
  var div_10 = child(div_9);
  var input_2 = sibling(child(div_10), 2);
  var div_11 = sibling(div_10, 2);
  var select_1 = sibling(child(div_11), 2);
  var option_3 = child(select_1);
  option_3.value = null == (option_3.__value = "all") ? "" : "all";
  var option_4 = sibling(option_3);
  option_4.value = null == (option_4.__value = "none") ? "" : "none";
  var node_2 = sibling(option_4);
  each(node_2, 17, () => get(uniqueScripts), index, ($$anchor2, script) => {
    var option_5 = root_3();
    var option_5_value = {};
    var text_1 = child(option_5);
    template_effect(() => {
      if (option_5_value !== (option_5_value = get(script))) {
        option_5.value = null == (option_5.__value = get(script)) ? "" : get(script);
      }
      set_text(text_1, get(script));
    });
    append($$anchor2, option_5);
  });
  var div_12 = sibling(div_11, 2);
  var input_3 = sibling(child(div_12), 2);
  var node_3 = sibling(div_12, 2);
  if_block(node_3, () => get(enablePlayerDistanceFilter), ($$anchor2) => {
    var div_13 = root_4();
    var input_4 = sibling(child(div_13), 2);
    bind_value(input_4, () => get(maxPlayerDistance), ($$value) => set(maxPlayerDistance, $$value));
    append($$anchor2, div_13);
  });
  var div_14 = sibling(node_3, 2);
  var select_2 = sibling(child(div_14), 2);
  var option_6 = child(select_2);
  option_6.value = null == (option_6.__value = "count") ? "" : "count";
  var option_7 = sibling(option_6);
  option_7.value = null == (option_7.__value = "distance") ? "" : "distance";
  var div_15 = sibling(div_1, 2);
  var node_4 = child(div_15);
  if_block(
    node_4,
    () => Object.keys(get(groupedEntities)).length === 0,
    ($$anchor2) => {
      var p = root_5();
      append($$anchor2, p);
    },
    ($$anchor2) => {
      var fragment = root_6();
      var div_16 = first_child(fragment);
      var div_17 = child(div_16);
      var span = child(div_17);
      var text_2 = child(span);
      template_effect(() => set_text(text_2, Object.keys(get(groupedEntities)).length));
      var div_18 = sibling(div_17, 2);
      var span_1 = child(div_18);
      var text_3 = child(span_1);
      template_effect(() => set_text(text_3, Object.values(get(groupedEntities)).reduce((acc, group) => acc + group.length, 0)));
      var div_19 = sibling(div_18, 2);
      var span_2 = child(div_19);
      var text_4 = child(span_2);
      var div_20 = sibling(div_19, 2);
      var span_3 = child(div_20);
      var text_5 = child(span_3);
      template_effect(() => set_text(text_5, Object.values(get(groupedEntities)).reduce((acc, group) => acc + group.filter((e) => e.isNetworked).length, 0)));
      var node_5 = sibling(div_16, 2);
      each(node_5, 17, () => Object.entries(get(groupedEntities)), index, ($$anchor3, $$item, groupIndex) => {
        let groupName = () => get($$item)[0];
        let group = () => get($$item)[1];
        {
          const children = ($$anchor4) => {
            var div_21 = root_8();
            each(div_21, 21, group, index, ($$anchor5, entity, index2) => {
              var div_22 = root_9();
              var div_23 = child(div_22);
              var div_24 = child(div_23);
              var text_6 = child(div_24);
              template_effect(() => set_text(text_6, get(entity).type.toUpperCase()));
              var div_25 = sibling(div_24, 2);
              var text_7 = child(div_25);
              var div_26 = sibling(div_23, 2);
              var div_27 = child(div_26);
              var text_8 = child(div_27);
              var div_28 = sibling(div_27, 2);
              var span_4 = sibling(child(div_28), 2);
              const stringified_text = /* @__PURE__ */ derived(() => get(entity).position.x.toFixed(1) ?? "");
              const stringified_text_1 = /* @__PURE__ */ derived(() => get(entity).position.y.toFixed(1) ?? "");
              const stringified_text_2 = /* @__PURE__ */ derived(() => get(entity).position.z.toFixed(1) ?? "");
              var text_9 = child(span_4);
              template_effect(() => set_text(text_9, `${get(stringified_text)}, ${get(stringified_text_1)}, ${get(stringified_text_2)}`));
              var node_6 = sibling(div_28, 2);
              if_block(node_6, () => get(entity).script, ($$anchor6) => {
                var div_29 = root_10();
                var span_5 = sibling(child(div_29), 2);
                var text_10 = child(span_5);
                template_effect(() => set_text(text_10, get(entity).script));
                append($$anchor6, div_29);
              });
              var div_30 = sibling(div_26, 2);
              var div_31 = child(div_30);
              var button = child(div_31);
              button.__click = [on_click, openEntityCamera, entity, group];
              var div_32 = sibling(button, 2);
              div_32.textContent = `#${index2 + 1}`;
              var div_33 = sibling(div_31, 2);
              var text_11 = child(div_33);
              template_effect(() => {
                toggle_class(div_24, "vehicle", get(entity).type === "vehicle");
                toggle_class(div_24, "object", get(entity).type === "object");
                toggle_class(div_24, "ped", get(entity).type === "ped");
                set_text(text_7, `Entity: ${get(entity).id ?? ""}`);
                set_text(text_8, get(entity).model);
                toggle_class(div_33, "networked", get(entity).isNetworked);
                set_text(text_11, get(entity).isNetworked ? "NET" : "LOCAL");
              });
              append($$anchor5, div_22);
            });
            append($$anchor4, div_21);
          };
          const headerContent = ($$anchor4) => {
            var div_34 = root_11();
            var span_6 = child(div_34);
            var text_12 = child(span_6);
            template_effect(() => set_text(text_12, `${new Set(group().map((e) => e.model)).size ?? ""} models`));
            var span_7 = sibling(span_6, 2);
            var text_13 = child(span_7);
            template_effect(() => set_text(text_13, `${group().filter((e) => e.isNetworked).length ?? ""} net`));
            append($$anchor4, div_34);
          };
          CollapsibleBox($$anchor3, {
            get title() {
              return groupName();
            },
            get showCount() {
              return group().length;
            },
            variant: groupIndex % 2 === 0 ? "primary" : "success",
            size: "md",
            isOpen: false,
            children,
            headerContent,
            $$slots: { default: true, headerContent: true }
          });
        }
      });
      template_effect(() => set_text(text_4, get(entities).length));
      append($$anchor2, fragment);
    }
  );
  var node_7 = sibling(div_15, 2);
  if_block(node_7, () => get(cameraEntity), ($$anchor2) => {
    EntityCamera($$anchor2, {
      get entityId() {
        return get(cameraEntity).id;
      },
      get coords() {
        return get(cameraEntity).position;
      },
      get groupEntities() {
        return get(cameraGroup);
      },
      get isOpen() {
        return get(showCamera);
      },
      onClose: closeCameraView
    });
  });
  bind_select_value(select, () => get(groupingMode), ($$value) => set(groupingMode, $$value));
  bind_checked(input_1, () => get(networked_only), ($$value) => set(networked_only, $$value));
  bind_value(input_2, () => get(entityFilter), ($$value) => set(entityFilter, $$value));
  bind_select_value(select_1, () => get(scriptFilter), ($$value) => set(scriptFilter, $$value));
  bind_checked(input_3, () => get(enablePlayerDistanceFilter), ($$value) => set(enablePlayerDistanceFilter, $$value));
  bind_select_value(select_2, () => get(sortBy), ($$value) => set(sortBy, $$value));
  append($$anchor, div);
  pop();
}
delegate(["click"]);
var root_1 = /* @__PURE__ */ template(`<div>Home Content</div>`);
var root$1 = /* @__PURE__ */ template(`<div id="side-panel-container" class="svelte-bp4pkb"><!> <div id="display-content" class="svelte-bp4pkb"><div class="content-wrapper svelte-bp4pkb"><!> <!> <!></div></div></div>`);
function SidePanel($$anchor, $$props) {
  push($$props, true);
  let activeTab = state(proxy(Tabs.HOME));
  var div = root$1();
  var node = child(div);
  Navigation(node, {
    get activeTab() {
      return get(activeTab);
    },
    set activeTab($$value) {
      set(activeTab, proxy($$value));
    }
  });
  var div_1 = sibling(node, 2);
  var div_2 = child(div_1);
  var node_1 = child(div_2);
  if_block(node_1, () => get(activeTab) === Tabs.HOME, ($$anchor2) => {
    var div_3 = root_1();
    append($$anchor2, div_3);
  });
  var node_2 = sibling(node_1, 2);
  if_block(node_2, () => get(activeTab) === Tabs.ENTITY, ($$anchor2) => {
    EntityChecker($$anchor2, {});
  });
  var node_3 = sibling(node_2, 2);
  if_block(node_3, () => get(activeTab) === Tabs.SETTINGS, ($$anchor2) => {
    Settings($$anchor2, {});
  });
  append($$anchor, div);
  pop();
}
var root = /* @__PURE__ */ template(`<main><!></main>`);
function VisibilityProvider($$anchor, $$props) {
  push($$props, true);
  ReceiveNUI("enableUI", (visible) => {
    console.log("enableUI", visible);
    providers.isVisible = visible || !providers.isVisible;
  });
  onMount(() => {
    if (!CONFIG.ESC_TO_EXIT) return;
    const keyHandler = (e) => {
      if (providers.isVisible && ["Escape"].includes(e.code)) {
        if (providers.cameraActive) {
          return;
        }
        SendNUI("closeUI");
        providers.isVisible = false;
      }
    };
    window.addEventListener("keydown", keyHandler);
    return () => window.removeEventListener("keydown", keyHandler);
  });
  var main = root();
  var node = child(main);
  if_block(node, () => providers.isVisible, ($$anchor2) => {
    var fragment = comment();
    var node_1 = first_child(fragment);
    snippet(node_1, () => $$props.children ?? noop);
    append($$anchor2, fragment);
  });
  append($$anchor, main);
  pop();
}
const InitDebug = [
  {
    action: "enableUI",
    data: true
  }
];
function InitializeDebugSenders() {
  for (const event of InitDebug) {
    SendDebugNUI({
      action: event.action,
      data: event.data
    });
  }
}
const ReceiveDebuggers = [
  {
    action: "getEntities",
    handler: () => {
      return {
        result: [
          // Cluster 1: Parking lot with cars (very close together)
          { id: "1(net:5)", type: "vehicle", model: "adder", position: { x: 100.5, y: 200.2, z: 30.1, w: 1 }, script: null, isNetworked: true },
          { id: "2(net:75)", type: "vehicle", model: "zentorno", position: { x: 102.1, y: 201.8, z: 30.1, w: 1 }, script: null, isNetworked: true },
          { id: "3", type: "vehicle", model: "adder", position: { x: 104.3, y: 200.5, z: 30.1, w: 1 }, script: null, isNetworked: false },
          { id: "4(net:88)", type: "vehicle", model: "infernus", position: { x: 101.7, y: 203.2, z: 30.1, w: 1 }, script: null, isNetworked: true },
          // Cluster 2: Traffic cones stacked on each other (0 distance)
          { id: "5", type: "object", model: "prop_roadcone02a", position: { x: 150, y: 150, z: 29.5, w: 1 }, script: "road_construction", isNetworked: false },
          { id: "6", type: "object", model: "prop_roadcone02a", position: { x: 150, y: 150, z: 29.5, w: 1 }, script: "road_construction", isNetworked: false },
          { id: "7", type: "object", model: "prop_roadcone02a", position: { x: 150, y: 150, z: 29.5, w: 1 }, script: "road_construction", isNetworked: false },
          { id: "8", type: "object", model: "prop_roadcone02a", position: { x: 150.1, y: 150.1, z: 29.5, w: 1 }, script: "road_construction", isNetworked: false },
          // Cluster 3: Gas station props
          { id: "9(net:123)", type: "object", model: "prop_gas_pump_1d", position: { x: 300.2, y: 400.1, z: 31.2, w: 1 }, script: "gas_station", isNetworked: true },
          { id: "10(net:124)", type: "object", model: "prop_gas_pump_1d", position: { x: 303.5, y: 400.3, z: 31.2, w: 1 }, script: "gas_station", isNetworked: true },
          { id: "11(net:125)", type: "object", model: "prop_gas_pump_old2", position: { x: 301.8, y: 402.7, z: 31.2, w: 1 }, script: "gas_station", isNetworked: true },
          { id: "12", type: "object", model: "prop_generator_03", position: { x: 299.1, y: 398.9, z: 31.2, w: 1 }, script: null, isNetworked: false },
          // Cluster 4: Dumpster area (multiple same models close together)
          { id: "13", type: "object", model: "prop_dumpster_02a", position: { x: 50.3, y: 75.7, z: 28.8, w: 1 }, script: null, isNetworked: false },
          { id: "14", type: "object", model: "prop_dumpster_02a", position: { x: 52.1, y: 76.2, z: 28.8, w: 1 }, script: null, isNetworked: false },
          { id: "15", type: "object", model: "prop_dumpster_02a", position: { x: 51.8, y: 78.9, z: 28.8, w: 1 }, script: null, isNetworked: false },
          { id: "16", type: "object", model: "prop_bin_05a", position: { x: 49.7, y: 77.1, z: 28.8, w: 1 }, script: null, isNetworked: false },
          { id: "17", type: "object", model: "prop_bin_05a", position: { x: 54.2, y: 75.3, z: 28.8, w: 1 }, script: null, isNetworked: false },
          // Cluster 5: Street lights in a line
          { id: "18(net:201)", type: "object", model: "prop_streetlight_01", position: { x: 500, y: 600, z: 32, w: 1 }, script: "street_lighting", isNetworked: true },
          { id: "19(net:202)", type: "object", model: "prop_streetlight_01", position: { x: 504.5, y: 600, z: 32, w: 1 }, script: "street_lighting", isNetworked: true },
          { id: "20(net:203)", type: "object", model: "prop_streetlight_01", position: { x: 509, y: 600, z: 32, w: 1 }, script: "street_lighting", isNetworked: true },
          { id: "21(net:204)", type: "object", model: "prop_streetlight_01", position: { x: 513.5, y: 600, z: 32, w: 1 }, script: "street_lighting", isNetworked: true },
          // Scattered individual items (should not group)
          { id: "22", type: "object", model: "prop_bench_01a", position: { x: 1e3, y: 1e3, z: 35, w: 1 }, script: null, isNetworked: false },
          { id: "23(net:301)", type: "object", model: "prop_tree_pine_01", position: { x: 2e3, y: 2e3, z: 40, w: 1 }, script: "landscaping", isNetworked: true },
          { id: "24(net:302)", type: "object", model: "prop_atm_01", position: { x: 3e3, y: 3e3, z: 30, w: 1 }, script: "banking", isNetworked: true },
          // Cluster 6: Construction site (mixed models, close together)
          { id: "25", type: "object", model: "prop_barrier_work05", position: { x: 800.1, y: 850.2, z: 25.3, w: 1 }, script: "construction", isNetworked: false },
          { id: "26", type: "object", model: "prop_barrier_work05", position: { x: 801.7, y: 851.8, z: 25.3, w: 1 }, script: "construction", isNetworked: false },
          { id: "27", type: "object", model: "prop_barrier_work05", position: { x: 803.2, y: 849.6, z: 25.3, w: 1 }, script: "construction", isNetworked: false },
          { id: "28", type: "object", model: "prop_tool_box_04", position: { x: 799.8, y: 852.1, z: 25.3, w: 1 }, script: "construction", isNetworked: false },
          { id: "29", type: "object", model: "prop_tool_box_04", position: { x: 804.5, y: 851.3, z: 25.3, w: 1 }, script: "construction", isNetworked: false },
          { id: "30(net:401)", type: "object", model: "prop_generator_01a", position: { x: 802.3, y: 853.7, z: 25.3, w: 1 }, script: "construction", isNetworked: true },
          // Cluster 7: Beach props
          { id: "31(net:501)", type: "object", model: "prop_beach_parasol_01", position: { x: 1200.5, y: 1300.7, z: 15.2, w: 1 }, script: "beach_setup", isNetworked: true },
          { id: "32(net:502)", type: "object", model: "prop_beach_parasol_01", position: { x: 1205.2, y: 1302.1, z: 15.2, w: 1 }, script: "beach_setup", isNetworked: true },
          { id: "33", type: "object", model: "prop_beach_chair_01", position: { x: 1201.8, y: 1299.4, z: 15.2, w: 1 }, script: null, isNetworked: false },
          { id: "34", type: "object", model: "prop_beach_chair_01", position: { x: 1203.7, y: 1304.8, z: 15.2, w: 1 }, script: null, isNetworked: false },
          { id: "35", type: "object", model: "prop_beach_chair_01", position: { x: 1207.1, y: 1300.9, z: 15.2, w: 1 }, script: null, isNetworked: false },
          // Cluster 8: Pharmacy/shop area (very close, overlapping)
          { id: "36", type: "object", model: "v_ret_ml_chips", position: { x: 650, y: 720, z: 35.5, w: 1 }, script: "shop_interior", isNetworked: false },
          { id: "37", type: "object", model: "v_ret_ml_chips", position: { x: 650.02, y: 720.01, z: 35.5, w: 1 }, script: "shop_interior", isNetworked: false },
          { id: "38", type: "object", model: "v_ret_ml_soda", position: { x: 650.1, y: 720.15, z: 35.5, w: 1 }, script: "shop_interior", isNetworked: false },
          { id: "39", type: "object", model: "v_ret_ml_soda", position: { x: 650.08, y: 720.12, z: 35.5, w: 1 }, script: "shop_interior", isNetworked: false },
          // Cluster 9: Large cluster of same vehicles (spawn glitch simulation)
          { id: "40(net:601)", type: "vehicle", model: "taxi", position: { x: 400, y: 500, z: 28, w: 1 }, script: "taxi_spawner", isNetworked: true },
          { id: "41(net:602)", type: "vehicle", model: "taxi", position: { x: 400.2, y: 500.1, z: 28, w: 1 }, script: "taxi_spawner", isNetworked: true },
          { id: "42(net:603)", type: "vehicle", model: "taxi", position: { x: 400.4, y: 500.2, z: 28, w: 1 }, script: "taxi_spawner", isNetworked: true },
          { id: "43(net:604)", type: "vehicle", model: "taxi", position: { x: 400.1, y: 499.8, z: 28, w: 1 }, script: "taxi_spawner", isNetworked: true },
          { id: "44(net:605)", type: "vehicle", model: "taxi", position: { x: 399.9, y: 500.3, z: 28, w: 1 }, script: "taxi_spawner", isNetworked: true },
          { id: "45(net:606)", type: "vehicle", model: "taxi", position: { x: 400.3, y: 499.9, z: 28, w: 1 }, script: "taxi_spawner", isNetworked: true },
          // Cluster 10: Furniture cluster (interior glitch simulation)
          { id: "46", type: "object", model: "v_res_tre_sofa", position: { x: 1500.2, y: 1600.3, z: 45.1, w: 1 }, script: "interior_decorator", isNetworked: false },
          { id: "47", type: "object", model: "v_res_tre_sofa", position: { x: 1501.1, y: 1600.8, z: 45.1, w: 1 }, script: "interior_decorator", isNetworked: false },
          { id: "48", type: "object", model: "v_res_tre_coffeetable", position: { x: 1500.7, y: 1601.2, z: 45.1, w: 1 }, script: "interior_decorator", isNetworked: false },
          { id: "49", type: "object", model: "v_res_tre_coffeetable", position: { x: 1500.9, y: 1599.9, z: 45.1, w: 1 }, script: "interior_decorator", isNetworked: false },
          // Some more isolated entities
          { id: "50(net:701)", type: "object", model: "prop_flag_us", position: { x: 5e3, y: 5e3, z: 50, w: 1 }, script: "government", isNetworked: true },
          { id: "51(net:702)", type: "object", model: "prop_windmill_01", position: { x: 6e3, y: 6e3, z: 100, w: 1 }, script: "renewable_energy", isNetworked: true },
          { id: "52(net:703)", type: "object", model: "prop_water_tower_01", position: { x: 7e3, y: 7e3, z: 80, w: 1 }, script: "utilities", isNetworked: true },
          // Edge case: Two clusters of same model far apart
          { id: "53", type: "object", model: "prop_bskball_01", position: { x: 900, y: 950, z: 30, w: 1 }, script: null, isNetworked: false },
          { id: "54", type: "object", model: "prop_bskball_01", position: { x: 902, y: 951, z: 30, w: 1 }, script: null, isNetworked: false },
          { id: "55", type: "object", model: "prop_bskball_01", position: { x: 1800, y: 1850, z: 35, w: 1 }, script: null, isNetworked: false },
          { id: "56", type: "object", model: "prop_bskball_01", position: { x: 1801.5, y: 1851.2, z: 35, w: 1 }, script: null, isNetworked: false },
          // Very tight cluster (problematic spawning)
          { id: "57(net:801)", type: "object", model: "prop_cash_trolly", position: { x: 250, y: 350, z: 40, w: 1 }, script: "bank_robbery", isNetworked: true },
          { id: "58(net:802)", type: "object", model: "prop_cash_trolly", position: { x: 250.001, y: 350.001, z: 40, w: 1 }, script: "bank_robbery", isNetworked: true },
          { id: "59(net:803)", type: "object", model: "prop_cash_trolly", position: { x: 250.002, y: 350.002, z: 40, w: 1 }, script: "bank_robbery", isNetworked: true },
          { id: "60(net:804)", type: "object", model: "prop_security_case_01", position: { x: 250.003, y: 350.003, z: 40, w: 1 }, script: "bank_robbery", isNetworked: true },
          { id: "61(net:805)", type: "object", model: "prop_bskball_01", position: { x: 250, y: 350, z: 40, w: 1 }, script: "basketball_event", isNetworked: true },
          { id: "62(net:806)", type: "object", model: "prop_bskball_01", position: { x: 250.001, y: 350.001, z: 40, w: 1 }, script: "basketball_event", isNetworked: true },
          { id: "63", type: "object", model: "prop_bskball_01", position: { x: 250.002, y: 350.002, z: 40, w: 1 }, script: null, isNetworked: false },
          { id: "64", type: "object", model: "prop_bskball_01", position: { x: 250.003, y: 350.003, z: 40, w: 1 }, script: null, isNetworked: false }
        ]
      };
    }
  }
];
function InitializeDebugReceivers() {
  for (const event of ReceiveDebuggers) {
    ReceiveDebugNUI(event.action, event.handler);
  }
}
function App($$anchor, $$props) {
  push($$props, false);
  if (CONFIG.IS_BROWSER) {
    InitializeDebugReceivers();
    InitializeDebugSenders();
  }
  init();
  VisibilityProvider($$anchor, {
    children: ($$anchor2, $$slotProps) => {
      SidePanel($$anchor2, {});
    },
    $$slots: { default: true }
  });
  pop();
}
const appElement = document.getElementById("app");
if (appElement) {
  mount(App, {
    target: appElement
  });
} else {
  console.error("Failed to initialize the app: #app element not found.");
}
