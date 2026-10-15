{ zed-editor }:
zed-editor.overrideAttrs (oldAttrs: {
  postPatch = (oldAttrs.postPatch or "") + ''
    # Hide the terminal panel tab bar.
    substituteInPlace crates/terminal_view/src/terminal_panel.rs \
      --replace-fail 'pane.set_should_display_tab_bar(|_, _| true);' \
        'pane.set_should_display_tab_bar(|_, _| false);'

    # Add breathing room above the terminal content (0.5 rem).
    sed -i '/terminal-view-container/ { N; s/\.size_full()/.pt_2().size_full()/; }' \
      crates/terminal_view/src/terminal_view.rs
  '';
})
