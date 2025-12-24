local M = {}

local function write_file(path, content)
  local file = io.open(path, "w")
  if file then
    file:write(content)
    file:close()
    print("Archivo creado: " .. path)
  else
    print("Error al crear archivo: " .. path)
  end
end

function M.setup()
  vim.api.nvim_create_user_command("CreateWeb3Config", function()
    local cwd = vim.fn.getcwd()

    local prettier = [[
module.exports = {
  semi: true,
  singleQuote: false,
  printWidth: 120,
  tabWidth: 2,
  plugins: ["prettier-plugin-solidity"],
};
// bun add -D prettier prettier-plugin-solidity solhint @biomejs/biome
]]

    local solhint = [[
{
  "extends": "solhint:recommended",
  "rules": {
    "compiler-version": ["error", "^0.8.0"],
    "func-order": "warn",
    "reason-string": ["warn", { "maxLength": 64 }],
    "no-empty-blocks": "error",
    "max-line-length": ["warn", 120]
  }
}
]]

    local biome = [[

{
  "$schema": "https://biomejs.dev/schemas/2.1.3/schema.json",
  "assist": {
    "actions": {
      "source": {
        "organizeImports": "on"
      }
    }
  },
  "formatter": {
    "enabled": true,
    "indentStyle": "space",
    "indentWidth": 2,
    "lineWidth": 120
  },
  "linter": {
    "enabled": true,
    "rules": {
      "recommended": true,
      "correctness": {
        "noUnusedVariables": "error",
        "noUnusedImports": "error",
        "noUndeclaredVariables": "error",
        "useExhaustiveDependencies": "warn"
      },
      "style": {
        "useConst": "error",
        "useSingleVarDeclarator": "error",
        "useTemplate": "error",
        "noNegationElse": "error"
      },
      "suspicious": {
        "noConsole": "warn",
        "noDebugger": "error",
        "noArrayIndexKey": "warn",
        "noEmptyBlockStatements": "error"
      },
      "complexity": {
        "noExcessiveCognitiveComplexity": "warn",
        "noUselessFragments": "error"
      },
      "performance": {
        "noAccumulatingSpread": "warn"
      }
    }
  },
  "javascript": {
    "parser": {
      "jsxEverywhere": true
    },
    "formatter": {
      "quoteStyle": "double",
      "semicolons": "always",
      "trailingCommas": "es5"
    },
    "globals": ["window", "document", "console", "process"]
  },
  "json": {
    "formatter": {
      "trailingCommas": "none"
    }
  },
  "css": {
    "formatter": {
      "enabled": true
    }
  },
  "files": {
    "includes": [
      "**",
      "**/*.sol",
      "!**/node_modules/**",
      "!**/.next/**",
      "!**/dist/**",
      "!**/build/**",
      "!**/*.min.js",
      "!**/coverage/**",
      "!**/.git/**",
      "!**/.env*"
    ]
  },
  "vcs": {
    "enabled": true,
    "clientKind": "git",
    "useIgnoreFile": true
  }
}
]]

    write_file(cwd .. "/prettier.config.cjs", prettier)
    write_file(cwd .. "/.solhint.json", solhint)
    write_file(cwd .. "/biome.json", biome)
  end, {})

  vim.api.nvim_create_user_command("CreateReactPrettierBiomeConfig", function()
    local cwd = vim.fn.getcwd()

    local prettier = [[
{
  "semi": true,
  "singleQuote": true,
  "printWidth": 100,
  "tabWidth": 2,
  "trailingComma": "es5"
}
]]

    local biome = [[
{
  "$schema": "https://biomejs.dev/schemas/2.1.3/schema.json",
  "assist": {
    "actions": {
      "source": {
        "organizeImports": "on"
      }
    }
  },
  "formatter": {
    "enabled": true,
    "indentStyle": "space",
    "indentWidth": 2,
    "lineWidth": 120
  },
  "linter": {
    "enabled": true,
    "rules": {
      "recommended": true,
      "correctness": {
        "noUnusedVariables": "error",
        "noUnusedImports": "error",
        "noUndeclaredVariables": "error",
        "useExhaustiveDependencies": "warn"
      },
      "style": {
        "useConst": "error",
        "useSingleVarDeclarator": "error",
        "useTemplate": "error",
        "noNegationElse": "error"
      },
      "suspicious": {
        "noConsole": "warn",
        "noDebugger": "error",
        "noArrayIndexKey": "warn",
        "noEmptyBlockStatements": "error"
      },
      "complexity": {
        "noExcessiveCognitiveComplexity": "warn",
        "noUselessFragments": "error"
      },
      "performance": {
        "noAccumulatingSpread": "warn"
      }
    }
  },
  "javascript": {
    "parser": {
      "jsxEverywhere": true
    },
    "formatter": {
      "quoteStyle": "double",
      "semicolons": "always",
      "trailingCommas": "es5"
    },
    "globals": ["window", "document", "console", "process"]
  },
  "json": {
    "formatter": {
      "trailingCommas": "none"
    }
  },
  "css": {
    "formatter": {
      "enabled": true
    }
  },
  "files": {
    "includes": [
      "**",
      "**/*.sol",
      "!**/node_modules/**",
      "!**/.next/**",
      "!**/dist/**",
      "!**/build/**",
      "!**/*.min.js",
      "!**/coverage/**",
      "!**/.git/**",
      "!**/.env*"
    ]
  },
  "vcs": {
    "enabled": true,
    "clientKind": "git",
    "useIgnoreFile": true
  }
}
]]

    write_file(cwd .. "/.prettierrc.json", prettier)
    write_file(cwd .. "/biome.json", biome)
  end, {})

  vim.api.nvim_create_user_command("CreateReactBiomeOnlyConfig", function()
    local cwd = vim.fn.getcwd()

    local biome = [[
{
  "$schema": "https://biomejs.dev/schemas/2.1.3/schema.json",
  "assist": {
    "actions": {
      "source": {
        "organizeImports": "on"
      }
    }
  },
  "formatter": {
    "enabled": true,
    "indentStyle": "space",
    "indentWidth": 2,
    "lineWidth": 120
  },
  "linter": {
    "enabled": true,
    "rules": {
      "recommended": true,
      "correctness": {
        "noUnusedVariables": "error",
        "noUnusedImports": "error",
        "noUndeclaredVariables": "error",
        "useExhaustiveDependencies": "warn"
      },
      "style": {
        "useConst": "error",
        "useSingleVarDeclarator": "error",
        "useTemplate": "error",
        "noNegationElse": "error"
      },
      "suspicious": {
        "noConsole": "warn",
        "noDebugger": "error",
        "noArrayIndexKey": "warn",
        "noEmptyBlockStatements": "error"
      },
      "complexity": {
        "noExcessiveCognitiveComplexity": "warn",
        "noUselessFragments": "error"
      },
      "performance": {
        "noAccumulatingSpread": "warn"
      }
    }
  },
  "javascript": {
    "parser": {
      "jsxEverywhere": true
    },
    "formatter": {
      "quoteStyle": "double",
      "semicolons": "always",
      "trailingCommas": "es5"
    },
    "globals": ["window", "document", "console", "process"]
  },
  "json": {
    "formatter": {
      "trailingCommas": "none"
    }
  },
  "css": {
    "formatter": {
      "enabled": true
    }
  },
  "files": {
    "includes": [
      "**",
      "**/*.sol",
      "!**/node_modules/**",
      "!**/.next/**",
      "!**/dist/**",
      "!**/build/**",
      "!**/*.min.js",
      "!**/coverage/**",
      "!**/.git/**",
      "!**/.env*"
    ]
  },
  "vcs": {
    "enabled": true,
    "clientKind": "git",
    "useIgnoreFile": true
  }
}
]]

    write_file(cwd .. "/biome.json", biome)
  end, {})
end

return M
