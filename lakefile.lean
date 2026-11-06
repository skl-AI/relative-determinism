cat << 'EOF' > lakefile.lean
import Lake

package relativeDeterminism where
  -- package configuration

@[default_target]
lean_lib RelativeDeterminism where
  -- library configuration
EOF
