<template>
  <div class="flex flex-col md:mx-[197px] mx-[10%] mt-[30px] md:mt-[123px]">
    <span class="text-[24px] text-white">My NFTs 🗻</span>
    <div class="md:flex flex-wrap gap-2 md:gap-[24px] mt-[32px]">
      <DataTable
        v-for="(item, i) in nodeStation"
        :key="i"
        :title="item.title"
        :icon="item.icon"
        :price="item.price"
        :percentage="item.percentage"
      />
    </div>
    <div class="md:mt-[40px]">
      <MyLuckyBoxesTable :items="luckyBoxes" @scroll-to-table="onScrollToTable" />
      <div ref="table">
        <NodeTable :items="nfts" />
      </div>
    </div>
    <div class="md:mt-[40px]">
      <MigrationTable />
    </div>
  </div>
</template>

<script lang="ts">
import { Component } from 'nuxt-property-decorator';
import WalletReactiveFetch, { IReactiveFetch } from '~/mixins/wallet-reactive-fetch';
import addresses from '~/config/addresses'
@Component
export default class Mynft extends WalletReactiveFetch implements IReactiveFetch {
  onScrollToTable () {
    const el = this.$refs.table;

    if (el) {
      (el as any).scrollIntoView({ behavior: 'smooth' });
    }
  }

  get nodeStation () {
    return [
      {
        icon: require('../assets/img/nodesIcon/totalnodes_icon.svg'),
        title: 'Pending Rewards',
        price: this.isWalletConnected ? this.$store.getters['nodes/totalPendingRewards'] : null,
        percentage: null,
      },
      {
        icon: require('../assets/img/nodesIcon/mynodes_icon.svg'),
        title: 'My Nodes',
        price: this.isWalletConnected ? this.$store.getters['nodes/myTotalCreated'] : null,
        percentage: null,
      },
      {
        icon: require('../assets/img/nodesIcon/polarbalance_icon.svg'),
        title: 'My $POLAR Balance',
        price: this.isWalletConnected ? this.$store.getters['tokens/balanceForToken'](addresses.Token) :null,
        percentage: null
      },
    ];
  }

  get nfts () {
    return this.$store.getters['nft/myNFTsByCreationDateDesc'];
  }

  get luckyBoxes () {
    return this.$store.state.luckyboxes.myLuckyBoxes ?? [];
  }

  async reactiveFetch () {
    if (this.isWalletConnected) {
      await this.$store.dispatch('nodes/loadOldNodeCount');
      await {
        lbTypes: await this.$store.dispatch('luckyboxes/loadLuckyBoxTypes'),
        myLbs: await this.$store.dispatch('luckyboxes/loadMyLuckyBoxes'),
        polarBalance: await this.$store.dispatch('tokens/loadBalance', addresses.Token),
        myNFTs: await (async () => {
          await this.$store.dispatch('nodes/loadNodeTypes');
          await this.$store.dispatch('nft/loadMyNFTs');
        })(),
      };
    }
  }

  created () {
    const interval = setInterval(() => {
      this.$fetch();
    }, 10000);

    this.$once('hook:beforeDestroy', () => {
      clearInterval(interval);
    });
  }
}
</script>
<style>
  .flex1 {
    height: 9rem !important;
  }
</style>