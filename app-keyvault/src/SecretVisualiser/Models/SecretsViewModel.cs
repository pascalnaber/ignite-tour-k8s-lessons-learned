using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace SecretVisualiser.Models
{
    public class SecretsViewModel
    {
        public SecretsViewModel()
        {
            this.Secrets = new List<Secret>();
        }

        public List<Secret> Secrets { get; }
    }

    public class Secret
    {
        public Secret(string name, string value)
        {
            this.Name = name;
            this.Value = value;
        }

        public string Name { get; set; }
        public string Value { get; set; }
    }
}
