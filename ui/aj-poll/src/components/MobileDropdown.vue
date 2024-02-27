<script setup lang="ts">
const props = defineProps<{
  githubUrl: string;
  websiteUrl: string;
}>();

const emit = defineEmits(['closeDropdown']);
const closeDropdown = () => emit('closeDropdown');
</script>

<template>
  <div class="mobile-dropdown fixed inset-6 z-50">
    <header>
      <div class="wrapper">
        <img class="logo" src="../assets/aj-logo.png" alt="AJ Poll Logo" />
        <h1>AJ Top 25 Poll</h1>
        <nav class="cursor-pointer">
          <p @click.prevent="closeDropdown">Close</p>
        </nav>
      </div>
      <div class="flex flex-col mt-8">
        <div class="collapse">
          <input type="radio" name="mobile-nav-accordion" />
          <div class="collapse-title text-xl font-medium">Polls</div>
          <div class="collapse-content flex flex-col">
            <RouterLink to="/polls/languages">Languages</RouterLink>
            <RouterLink to="/polls/components">Components</RouterLink>
            <RouterLink to="/polls/companies">Companies</RouterLink>
          </div>
        </div>
        <div class="collapse">
          <input type="radio" name="mobile-nav-accordion" />
          <div class="collapse-title text-xl font-medium">About</div>
          <div class="collapse-content flex flex-col">
            <RouterLink to="/about">About</RouterLink>
            <a :href="props.githubUrl" target="_blank">
              GitHub
              <font-awesome-icon icon="arrow-up-right-from-square" />
            </a>
            <a :href="props.websiteUrl" target="_blank">
              My Website
              <font-awesome-icon icon="arrow-up-right-from-square" />
            </a>
          </div>
        </div>
      </div>
    </header>
  </div>
</template>

<style scoped>
.mobile-dropdown {
  background-color: var(--color-background);
}

header {
  line-height: 1.5;
  height: 5rem;
}

.wrapper {
  display: flex;
  align-items: center;
}

.logo {
  display: block;
  max-height: 3rem;
}

h1 {
  font-size: 1.5rem;
  margin: 0 1rem;
  text-transform: none;
}

nav {
  margin-left: auto;
  align-items: center;
  justify-content: center;
  font-size: 1rem;
  font-weight: 600;
  text-transform: uppercase;
}
</style>
