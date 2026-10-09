# MaclinOS Design System

## 1. Color Palette

### Primary Accent
Inspired by modern blue tones — original, not Apple's exact values.

```
--accent-primary:       hsl(215, 100%, 50%);   /* #0066FF */
--accent-primary-hover: hsl(215, 100%, 45%);   /* #005CE6 */
--accent-primary-press: hsl(215, 100%, 40%);   /* #0052CC */
--accent-primary-muted: hsl(215, 100%, 50%, 0.15);
```

### Light Theme

```
--bg-primary:       #FFFFFF;
--bg-secondary:     #F5F5F7;
--bg-tertiary:      #ECECEE;
--bg-elevated:      #FFFFFF;

--surface-panel:    rgba(255, 255, 255, 0.80);
--surface-dock:     rgba(245, 245, 247, 0.75);
--surface-menu:     rgba(255, 255, 255, 0.90);
--surface-overlay:  rgba(0, 0, 0, 0.40);

--text-primary:     #1D1D1F;
--text-secondary:   #6E6E73;
--text-tertiary:    #AEAEB2;
--text-inverse:     #FFFFFF;

--border-default:   rgba(0, 0, 0, 0.10);
--border-strong:    rgba(0, 0, 0, 0.20);
--border-focus:     hsl(215, 100%, 50%);

--status-success:   #30D158;
--status-warning:   #FF9F0A;
--status-error:     #FF3B30;
--status-info:      #0A84FF;
```

### Dark Theme

```
--bg-primary:       #1C1C1E;
--bg-secondary:     #2C2C2E;
--bg-tertiary:      #3A3A3C;
--bg-elevated:      #2C2C2E;

--surface-panel:    rgba(44, 44, 46, 0.80);
--surface-dock:     rgba(58, 58, 60, 0.75);
--surface-menu:     rgba(44, 44, 46, 0.90);
--surface-overlay:  rgba(0, 0, 0, 0.60);

--text-primary:     #F5F5F7;
--text-secondary:   #AEAEB2;
--text-tertiary:    #6E6E73;
--text-inverse:     #1D1D1F;

--border-default:   rgba(255, 255, 255, 0.10);
--border-strong:    rgba(255, 255, 255, 0.20);
--border-focus:     hsl(215, 100%, 55%);

--status-success:   #30D158;
--status-warning:   #FFD60A;
--status-error:     #FF453A;
--status-info:      #0A84FF;
```

---

## 2. Typography

### Font Stack
```
--font-system:   'Inter', -apple-system, BlinkMacSystemFont, 'Segoe UI', sans-serif;
--font-mono:     'JetBrains Mono', 'Fira Code', 'Cascadia Code', monospace;
--font-display:  'Inter', sans-serif;
```

### Type Scale (rem-based, 16px root)

| Token | Size | Weight | Line Height | Usage |
|-------|------|--------|-------------|-------|
| `--type-hero` | 2.5rem (40px) | 700 | 1.1 | Login screen title |
| `--type-title1` | 1.75rem (28px) | 700 | 1.2 | Section headers |
| `--type-title2` | 1.375rem (22px) | 600 | 1.25 | Dialog titles |
| `--type-title3` | 1.125rem (18px) | 600 | 1.3 | Card headers |
| `--type-headline` | 1rem (16px) | 600 | 1.4 | Emphasized body |
| `--type-body` | 0.875rem (14px) | 400 | 1.5 | Default body text |
| `--type-callout` | 0.8125rem (13px) | 400 | 1.4 | Panel text |
| `--type-caption` | 0.75rem (12px) | 400 | 1.3 | Timestamps, labels |
| `--type-micro` | 0.6875rem (11px) | 500 | 1.2 | Badges, counters |

---

## 3. Spacing & Layout

### Spacing Scale (4px base)
```
--space-0:  0px;
--space-1:  4px;
--space-2:  8px;
--space-3:  12px;
--space-4:  16px;
--space-5:  20px;
--space-6:  24px;
--space-8:  32px;
--space-10: 40px;
--space-12: 48px;
--space-16: 64px;
```

### Corner Radii
```
--radius-none:   0;
--radius-sm:     4px;
--radius-md:     8px;
--radius-lg:     12px;
--radius-xl:     16px;
--radius-2xl:    20px;
--radius-full:   9999px;
--radius-window: 10px;   /* Window corner radius */
--radius-dock:   16px;   /* Dock corner radius */
--radius-menu:   8px;    /* Menu/popup radius */
```

### Icon Sizes
```
--icon-xs:    12px;
--icon-sm:    16px;
--icon-md:    20px;
--icon-lg:    24px;
--icon-xl:    32px;
--icon-2xl:   48px;
--icon-dock:  48px;   /* Dock icon size */
--icon-launcher: 64px; /* Launcher grid icon */
```

---

## 4. Elevation & Shadows

```
/* Light theme shadows */
--shadow-sm:     0 1px 2px rgba(0, 0, 0, 0.06);
--shadow-md:     0 4px 12px rgba(0, 0, 0, 0.08);
--shadow-lg:     0 8px 24px rgba(0, 0, 0, 0.12);
--shadow-xl:     0 16px 48px rgba(0, 0, 0, 0.16);
--shadow-dock:   0 8px 32px rgba(0, 0, 0, 0.18);
--shadow-window: 0 12px 40px rgba(0, 0, 0, 0.15);
--shadow-menu:   0 6px 20px rgba(0, 0, 0, 0.12);

/* Dark theme shadows (darker, more diffuse) */
--shadow-sm-dark:     0 1px 2px rgba(0, 0, 0, 0.20);
--shadow-md-dark:     0 4px 12px rgba(0, 0, 0, 0.30);
--shadow-lg-dark:     0 8px 24px rgba(0, 0, 0, 0.40);
--shadow-xl-dark:     0 16px 48px rgba(0, 0, 0, 0.50);
```

---

## 5. Motion & Animation

### Duration Scale
```
--duration-instant:  0ms;
--duration-fast:     100ms;
--duration-normal:   200ms;
--duration-slow:     350ms;
--duration-slower:   500ms;
--duration-enter:    250ms;
--duration-exit:     200ms;
```

### Easing Curves
```
--ease-default:    cubic-bezier(0.25, 0.1, 0.25, 1.0);
--ease-in:         cubic-bezier(0.42, 0, 1.0, 1.0);
--ease-out:        cubic-bezier(0, 0, 0.58, 1.0);
--ease-in-out:     cubic-bezier(0.42, 0, 0.58, 1.0);
--ease-spring:     cubic-bezier(0.34, 1.56, 0.64, 1.0);
--ease-bounce:     cubic-bezier(0.68, -0.6, 0.32, 1.6);
```

### Reduced Motion
When `prefers-reduced-motion: reduce` is active:
- All durations → `--duration-instant` or `--duration-fast`
- No spring/bounce easing
- Fade transitions only (no scale/translate)
- Dock magnification disabled

---

## 6. Translucency & Blur

```
--blur-panel:    saturate(180%) blur(20px);
--blur-dock:     saturate(200%) blur(24px);
--blur-menu:     saturate(180%) blur(16px);
--blur-overlay:  blur(30px);
--blur-login:    blur(40px);
```

---

## 7. Display Scaling

| Scale | Base Font | Dock Icons | Panel Height | Window Radius |
|-------|-----------|------------|--------------|---------------|
| 100% (1x) | 14px | 48px | 28px | 10px |
| 125% | 17.5px | 60px | 35px | 12px |
| 150% | 21px | 72px | 42px | 15px |
| 200% (2x) | 28px | 96px | 56px | 20px |

All dimensions use logical pixels; KDE Plasma handles physical pixel mapping.

---

## 8. Accessibility

### Contrast Targets
- **Normal text**: ≥ 4.5:1 against background (WCAG AA)
- **Large text**: ≥ 3:1 against background
- **Interactive elements**: ≥ 3:1 against adjacent colors
- **Focus indicators**: ≥ 3:1 against background, 2px minimum width

### High Contrast Mode
- Increase all border opacity to 100%
- Disable translucency/blur
- Use solid backgrounds instead of semi-transparent surfaces
- Increase text weight by one step
- Ensure `--status-*` colors meet contrast requirements on both themes

### Focus Indicators
```
--focus-ring:       0 0 0 2px var(--bg-primary), 0 0 0 4px var(--accent-primary);
--focus-ring-error: 0 0 0 2px var(--bg-primary), 0 0 0 4px var(--status-error);
```

---

## 9. Component Specifications

### Top Bar (Panel)
- Height: 28px (logical)
- Background: `--surface-panel` with `--blur-panel`
- Left: App menu / title for active window
- Center: Clock (HH:MM, Day Month Date)
- Right: System tray icons (16px), battery, Wi-Fi, sound, notifications

### Dock
- Position: Bottom center, floating
- Height: 68px (48px icons + 20px padding)
- Background: `--surface-dock` with `--blur-dock`
- Corner radius: `--radius-dock`
- Shadow: `--shadow-dock`
- Icon size: 48px default, 64px on hover (magnification)
- Running indicator: 4px circle below icon, `--text-primary`
- Separator: 1px vertical line between pinned and running apps
- Auto-hide: configurable, 250ms slide animation

### Window Decorations
- Title bar height: 28px
- Corner radius: `--radius-window` (top corners only)
- Traffic light buttons: close (red), minimize (yellow/amber), maximize (green)
  - Size: 12px diameter
  - Spacing: 8px between centers
  - Position: Left side, 8px from edges
- Title: centered, `--type-callout`, `--text-primary`
- Shadow: `--shadow-window`

### Application Launcher
- Trigger: Super key, hot corner (configurable), dock icon
- Layout: Centered overlay with search field at top
- Background: `--surface-overlay` (full screen dim) + centered panel
- Search: `--type-title3`, auto-focus
- Results: Grid of icons (64px) with labels, or list view for search results
- Animation: Scale from 0.95 to 1.0 + fade in, `--duration-enter`

### Notifications
- Position: Top-right corner
- Width: 340px
- Background: `--surface-menu` with `--blur-menu`
- Corner radius: `--radius-lg`
- Shadow: `--shadow-md`
- Enter: Slide from right, `--duration-enter`
- Grouped by application
- Do-not-disturb toggle in quick settings

---

## 10. Reference States

Pixel-level reference screenshots/mockups needed for:

1. Desktop (empty, with windows, with dock/panel)
2. Application launcher (idle, searching, results)
3. Notification center (single, grouped, DND)
4. Settings app (general view)
5. File manager (icon view, list view, sidebar)
6. Login screen (single user, multi-user)
7. Lock screen
8. Overview / Mission Control
9. Context menus
10. Light and dark variants of all above
